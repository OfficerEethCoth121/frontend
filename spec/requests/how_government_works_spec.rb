RSpec.describe "How Government Works" do
  let(:content_item) { GovukSchemas::Example.find("how_government_works", example_name: "reshuffle-mode-off") }
  let(:base_path) { content_item.fetch("base_path") }

  before do
    stub_content_store_has_item(base_path, content_item)
  end

  describe "GET show" do
    it "returns 200" do
      get base_path

      expect(response).to have_http_status(:ok)
    end

    it "renders the show template" do
      get base_path

      expect(response).to render_template(:show)
    end

    it "sets cache-control headers" do
      get base_path
      expect(response).to honour_content_store_ttl
    end

    context "when the current prime minister has no image" do
      let(:content_item) do
        GovukSchemas::Example.find("how_government_works", example_name: "reshuffle-mode-off").tap do |item|
          person = item.fetch("links").fetch("current_prime_minister").first
          person["details"] ||= {}
          person["details"].delete("image")
          person.delete("image")
        end
      end

      it "renders the page without raising an error" do
        get base_path
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
