describe CsvToSeeds::CsvSeedsFile do
  it "should require a filepath" do
    expect { CsvToSeeds::CsvSeedsFile.new({}) }.to raise_error(ArgumentError)
    expect { CsvToSeeds::CsvSeedsFile.new(filepath: "file.csv") }.not_to raise_error
  end

  it "should use a comma column-separator by default" do
    file = CsvToSeeds::CsvSeedsFile.new(filepath: "file.csv")
    expect(file.col_sep).to eq(',')
  end

  it "should use a double-quote quote-char by default" do
    file = CsvToSeeds::CsvSeedsFile.new(filepath: "file.csv")
    expect(file.quote_char).to eq('"')
  end

  it "should return seeds in an array" do
    file = CsvToSeeds::CsvSeedsFile.new(filepath: "./spec/fixtures/person.csv")
    expect(file.seeds.class).to eq(Array)
    expect(file.seeds.length).to eq(3)
  end

  it "should infer the model name from filename of CSV (if not specific)" do
    file = CsvToSeeds::CsvSeedsFile.new(filepath: "./spec/fixtures/person.csv")
    expect(file.seeds.first).to include("Person.find_or_create_by")
  end

  it "should use the model name specified by the user" do
    file = CsvToSeeds::CsvSeedsFile.new(filepath: "./spec/fixtures/person.csv", model_name: "Hero")
    expect(file.seeds.first).to include("Hero.find_or_create_by")
  end

  it "should create ActiveRecord inserts to be used in seed file" do
    file = CsvToSeeds::CsvSeedsFile.new(filepath: "./spec/fixtures/person.csv")
    marty = file.seeds.first
    expect(marty).to eq('Person.find_or_create_by({:first_name=>"Marty", :last_name=>"McFly", :city=>"Hill Valley"})')
  end

  it "shouldn't create anything for blank file" do
    file = CsvToSeeds::CsvSeedsFile.new(filepath: "./spec/fixtures/empty.csv")
    expect(file.seeds.length).to eq(0)
  end
end
