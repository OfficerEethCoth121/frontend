RSpec.describe "Help" do
  describe "the help index page" do
    before do
      payload = {
        base_path: "/help",
        format: "special_route",
        title: "Help using GOV.UH",
        description: "",
        links: {},
      }
      stub_content_store_has_item("/help", payload)
    end

    it "renders the help index page correctly" do
      visit "/help"

      expect(page).to have_title("Help using GOV.UH")
      expect(page).to have_link(href: "/help/about-govuh")
      expect(page).to have_link(href: "/help/reuse-govuh-content")
      expect(page).not_to have_link(href: "/help/about-govuk")
      expect(page).not_to have_link(href: "/help/reuse-govuk-content")
    end
  end
end
