ARG ruby_version=4.0
ARG base_image=ghcr.io/alphagov/govuk-ruby-base:$ruby_version
ARG builder_image=ghcr.io/alphagov/govuk-ruby-builder:$ruby_version


FROM --platform=$TARGETPLATFORM $builder_image AS builder

WORKDIR $APP_HOME
COPY Gemfile* .ruby-version ./
RUN bundle install
COPY package.json yarn.lock ./
RUN npm install -g yarn@1.22.19 && yarn install --immutable
# Git-pinned source gems do not include the npm files bundled in the published GOV.UK gem.
# Install the original components' locked assets in their own source directory.
RUN components_dir="$(bundle show govuk_publishing_components)" && \
    mkdir -p /tmp/govuk-components-assets && \
    cp "$components_dir/package.json" "$components_dir/yarn.lock" /tmp/govuk-components-assets/ && \
    cd /tmp/govuk-components-assets && \
    node "$(npm root -g)/yarn/bin/yarn.js" install --frozen-lockfile --ignore-scripts && \
    cp -a node_modules "$components_dir/node_modules"
COPY . .
RUN bootsnap precompile --gemfile .
RUN rails assets:precompile && rm -fr log


FROM --platform=$TARGETPLATFORM $base_image

ENV GOVUK_APP_NAME=frontend

WORKDIR $APP_HOME
COPY --from=builder $BUNDLE_PATH $BUNDLE_PATH
COPY --from=builder $BOOTSNAP_CACHE_DIR $BOOTSNAP_CACHE_DIR
COPY --from=builder $APP_HOME .

USER app
CMD ["puma"]
