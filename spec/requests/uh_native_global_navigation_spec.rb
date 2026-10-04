# frozen_string_literal: true


RSpec.describe "Native GOV.UH global navigation", type: :request do
  include ContentStoreHelpers

  before { stub_homepage_content_item }

  it "renders the pinned GOV.UK shared super navigation, not a separate custom menu" do
    get "/"

    expect(response).to have_http_status(:ok)
    expect(response.body).to include("gem-c-layout-super-navigation-header")
    expect(response.body).to include("data-module=\"super-navigation-mega-menu\"")
    expect(response.body).to include("id=\"super-navigation-menu-toggle\"")
    expect(response.body).to include("id=\"super-navigation-menu\"")
    expect(response.body).to include("id=\"super-search-menu\"")
    expect(response.body).not_to include("govuh-menu-button")
    expect(response.body).not_to include("govuh-global-menu-panel")
  end

  it "locks the official publishing-components fork to its reviewed revision" do
    gemfile = File.read(Rails.root.join("Gemfile"))
    lockfile = File.read(Rails.root.join("Gemfile.lock"))

    ref = "78d059201b6ad4b1cddadb1351d01fe5ed9f2ff6"
    expect(gemfile).to include("https://github.com/bravogov/govuk_publishing_components.git")
    expect(gemfile).to include(ref)
    expect(lockfile).to include("revision: #{ref}")
    expect(lockfile).to include("govuk_publishing_components (70.2.0)")
  end
end
