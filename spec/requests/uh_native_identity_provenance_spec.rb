# frozen_string_literal: true

require "digest"

RSpec.describe "GOV.UH native shared identity", type: :request do
  include ContentStoreHelpers

  before { stub_homepage_content_item }

  let(:approved_crown_sha256) { "293218916b282a75c89326fab581942fe1f46652a32d122c17d47c9545398675" }

  it "renders the approved UH crown through the original Publishing Components logo seam" do
    get "/"
    expect(response).to have_http_status(:ok)

    page = Nokogiri::HTML(response.body)
    logo = page.at_css(".gem-c-layout-super-navigation-header__header-logo .gem-c-uh-logotype[aria-label='GOV.UH']")
    expect(logo).not_to be_nil

    crown = logo.at_css("img.gem-c-uh-logotype__crown[src*='uh_header_crown']")
    expect(crown).not_to be_nil
    expect(crown["alt"]).to eq("")
    expect(logo.text).to include("GOV.UH")

    component_root = Gem.loaded_specs.fetch("govuk_publishing_components").full_gem_path
    native_artwork = File.join(component_root, "app/assets/images/govuk_publishing_components/uh_header_crown.png")
    expect(Digest::SHA256.file(native_artwork).hexdigest).to eq(approved_crown_sha256)
  end

  it "does not load superseded continuity navigation or unrelated crown artwork" do
    get "/"
    expect(response).to have_http_status(:ok)

    expect(response.body).not_to include("uh-native-supernav.css")
    expect(response.body).not_to include("uh-native-supernav.js")
    expect(response.body).not_to include("uh-header-crown-white.webp")
    expect(response.body).not_to include("govuk-header-crown-white.svg")
    expect(response.body).not_to include('aria-label="GOV.UK"')
  end
end
