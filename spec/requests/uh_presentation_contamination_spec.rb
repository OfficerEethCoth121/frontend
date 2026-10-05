# frozen_string_literal: true

RSpec.describe "GOV.UH presentation contamination", type: :request do
  include ContentStoreHelpers

  before { stub_homepage_content_item }

  it "does not render retired continuity presentation assets" do
    get "/"
    expect(response).to have_http_status(:ok)

    retired_assets = [
      "uh-native-supernav.css",
      "uh-native-supernav.js",
      "phase7-overrides.css",
      "/uh-brand/",
      "/assets/gov-uh/",
      "uh-header-crown-white.webp",
      "uh-footer-crown.webp",
      "uh-government-coat-of-arms.webp",
    ]

    retired_assets.each { |asset| expect(response.body).not_to include(asset) }
  end
end
