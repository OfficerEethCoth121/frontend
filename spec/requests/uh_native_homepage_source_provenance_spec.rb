require "digest"

RSpec.describe "GOV.UH upstream Frontend homepage provenance" do
  it "preserves all seven original GOV.UK homepage templates byte-for-byte" do
    expect(Digest::SHA256.file(Rails.root.join("app/views/homepage/_government_activity.html.erb")).hexdigest).to eq("92cd1d2ea6ceebcaff7bb0914620c0f09fc3ec89bf21f8d43eb556eb7e4a1ccb")
    expect(Digest::SHA256.file(Rails.root.join("app/views/homepage/_homepage_header.html.erb")).hexdigest).to eq("4aef456bdf800ce66a6c468e428a87bd7b4ccab7f9ee65234a87390e782185ca")
    expect(Digest::SHA256.file(Rails.root.join("app/views/homepage/_more_on_govuk.html.erb")).hexdigest).to eq("87c58d43bb81167a8fe659538de979989f84f302d9ff256635955b998b1681ce")
    expect(Digest::SHA256.file(Rails.root.join("app/views/homepage/_popular_links.html.erb")).hexdigest).to eq("cd957bf076bb873e74507064ae8d0367f27b2ab7cfdbecf8826a57e66a70fcba")
    expect(Digest::SHA256.file(Rails.root.join("app/views/homepage/_promotion_slots.html.erb")).hexdigest).to eq("c95a9a7c693a4aa997ec85410b440d2efba474642e8ae950f6a4d717898d31d6")
    expect(Digest::SHA256.file(Rails.root.join("app/views/homepage/_services_and_information.html.erb")).hexdigest).to eq("d40d3bf50b78c080f14f37aac9a528c2a33805e7949067c84a84976fbf5959d5")
    expect(Digest::SHA256.file(Rails.root.join("app/views/homepage/index.html.erb")).hexdigest).to eq("76e79d73180c5f7c21c6407424c4e02fabfb7931a98b0f320cb39a7b56e10deb")
  end

  it "uses the original GOV.UK homepage heading through the normal Frontend locale" do
    expect(I18n.t("homepage.index.intro_html", locale: :en)).to eq("The best place to find government services and information")
    expect(I18n.t("homepage.index.intro_title.text", locale: :en)).to eq("Welcome to GOV.UH")
    expect(I18n.t("homepage.index.services_and_information", locale: :en)).to eq("Services and information")
  end

  it "keeps the GOV.UH homepage content free of inherited UK service material" do
    category_titles = I18n.t("homepage.categories", locale: :en).map { |item| item[:title] }
    expect(category_titles).to eq([
      "Citizenship and living in Havenstead",
      "Crime, justice and the law",
      "Disabled people and accessibility",
      "Education and learning",
      "Employing people",
      "Infrastructure and local services",
      "Money and tax",
      "Passports, travel and living abroad",
      "Visas and immigration",
      "Working, jobs and skills",
      "Wellbeing, safeguarding and care",
      "Government and democracy",
    ])

    expect(I18n.t("homepage.index.more_links", locale: :en)).to eq([])
    expect(I18n.t("homepage.index.promotion_slots", locale: :en)).to eq([])
    expect(I18n.t("homepage.index.promotion_slots_secondary", locale: :en)).to eq([])

    homepage_text = I18n.t("homepage.categories", locale: :en).flatten.join(" ")
    expect(homepage_text).not_to match(/Return to United Hampshire|Civil Service careers|membership-immigration|ministerial-expression-of-interest|public-sessions-and-activities/)
    expect(homepage_text).not_to match(/HMRC|Universal Credit|State Pension|Self Assessment|MOT|GOV\.UK app|National Insurance|Cost of living support/)
  end
end
