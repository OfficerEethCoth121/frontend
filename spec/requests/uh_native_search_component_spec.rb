# frozen_string_literal: true

RSpec.describe "Native GOV.UH site search", type: :request do
  include ContentStoreHelpers

  before { stub_homepage_content_item }

  it "renders the upstream shared super-navigation search and autocomplete" do
    get "/"

    expect(response).to have_http_status(:ok)

    page = Nokogiri::HTML(response.body)
    panel = page.at_css("#super-search-menu")
    expect(panel).not_to be_nil

    form = panel.at_css("form.gem-c-layout-super-navigation-header__search-form[action='/search/all'][method='get'][role='search']")
    expect(form).not_to be_nil

    autocomplete = form.at_css(".gem-c-search-with-autocomplete[data-module='gem-search-with-autocomplete']")
    expect(autocomplete).not_to be_nil
    expect(autocomplete["data-source-url"]).to end_with("/api/search/autocomplete.json")
    expect(autocomplete["data-source-key"]).to eq("suggestions")

    expect(autocomplete.at_css("label").text).to include("Search GOV.UH")
    expect(autocomplete.at_css("input.gem-c-search__input[type='search'][name='keywords']")).not_to be_nil
    expect(autocomplete.at_css("button.gem-c-search__submit[type='submit']")).not_to be_nil
    expect(response.body).not_to include("uh-native-supernav.css")
  end

  it "imports the original shared search styles and JavaScript through the native Frontend assets" do
    sass = Rails.root.join("app/assets/stylesheets/application.scss").read
    javascript = Rails.root.join("app/assets/javascripts/dependencies.js").read

    expect(sass).to include('@import "govuk_publishing_components/components/layout-super-navigation-header";')
    expect(sass).to include('@import "govuk_publishing_components/components/search";')
    expect(sass).to include('@import "govuk_publishing_components/components/search-with-autocomplete";')

    expect(javascript).to include("//= require govuk_publishing_components/components/layout-super-navigation-header")
    expect(javascript).to include("//= require govuk_publishing_components/components/search-with-autocomplete")
  end
end
