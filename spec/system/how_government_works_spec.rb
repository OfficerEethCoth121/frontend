RSpec.describe "How Government Works" do
  context "when visiting /government/how-government-works" do
    let(:content_item) { GovukSchemas::Example.find(:how_government_works, example_name: "reshuffle-mode-off") }
    let(:base_path) { content_item["base_path"] }

    before { stub_content_store_has_item(base_path, content_item) }

    it "displays the title" do
      visit base_path

      expect(page).to have_title("How government works")
    end

    it "displays the current prime minister" do
      visit base_path

      expect(page).to have_text(content_item.dig("links", "current_prime_minister", 0, "title"))
    end

    it "uses United Hampshire institutional links instead of UK public-service URLs" do
      visit base_path

      expect(page).to have_link("Read United Hampshire legislation", href: "https://legislation.gov.uhrblx.com/")
      expect(page).to have_link("Find out how United Hampshire Parliament works", href: "https://parliament.uhrblx.com/")
      expect(page).to have_link("Read more about the Chief Minister’s Office, 10 Harrington Court", href: "/government/organisations/chief-ministers-office-10-harrington-court")
      expect(page).not_to have_link(href: "https://www.legislation.gov.uk")
      expect(page).not_to have_css('img[src*="10_downing_street"], img[src*="churchill_01"], img[src*="cabinet_01"]')
    end

    it "renders without a minister image when the linked minister has no photograph" do
      no_image_item = Marshal.load(Marshal.dump(content_item))
      no_image_item.fetch("links").fetch("current_prime_minister").first.delete("image")
      stub_content_store_has_item(base_path, no_image_item)

      visit base_path

      expect(page).to have_text("The Chief Minister")
      expect(page).to have_text("In United Hampshire, the Chief Minister leads the government")
      expect(page).not_to have_text("In the UK, the Prime Minister")
      expect(page).not_to have_css('img[src*="10_downing_street"]')
    end

    it "displays the count of ministers" do
      visit base_path

      expect(page).to have_selector(".gem-c-big-number", text: /#{content_item.dig('details', 'ministerial_role_counts', 'prime_minister')}.+Chief Minister/m)
      expect(page).to have_selector(".gem-c-big-number", text: /#{content_item.dig('details', 'ministerial_role_counts', 'cabinet_ministers')}.+Cabinet ministers/m)
      expect(page).to have_selector(".gem-c-big-number", text: /#{content_item.dig('details', 'ministerial_role_counts', 'other_ministers')}.+Other ministers/m)
      expect(page).to have_selector(".gem-c-big-number", text: /#{content_item.dig('details', 'ministerial_role_counts', 'total_ministers')}.+Total ministers/m)
    end

    it "displays the count of departments" do
      visit base_path

      expect(page).to have_selector(".gem-c-big-number", text: /#{content_item.dig('details', 'department_counts', 'ministerial_departments')}.+Ministerial departments/m)
      expect(page).to have_selector(".gem-c-big-number", text: /#{content_item.dig('details', 'department_counts', 'non_ministerial_departments')}.+Non-ministerial departments/m)
      expect(page).to have_selector(".gem-c-big-number", text: /#{content_item.dig('details', 'department_counts', 'agencies_and_other_public_bodies')}.+Agencies and other public bodies/m)
    end

    context "when reshuffle mode is on" do
      let(:content_item) { GovukSchemas::Example.find(:how_government_works, example_name: "reshuffle-mode-on") }

      it "does not display the count of minister" do
        visit base_path

        expect(page).not_to have_selector(".gem-c-big-number", text: /Chief Minister/m)
        expect(page).not_to have_selector(".gem-c-big-number", text: /Cabinet ministers/m)
        expect(page).not_to have_selector(".gem-c-big-number", text: /Other ministers/m)
        expect(page).not_to have_selector(".gem-c-big-number", text: /Total ministers/m)
      end
    end
  end
end
