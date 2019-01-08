# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# https://github.com/el-cms/Open-trivia-database

require 'open-uri'

def populate(data)
  data.each { |d|
    category = Category.find_or_create_by(:title => d["category_id"].titleize)
    Questionnaire.create(:title => d["question"],
                         :answer => d["answers"][0],
                         :category => category)
  }
end

# data = JSON.load(open('https://raw.githubusercontent.com/el-cms/Open-trivia-database/master/en/todo/arts_and_literature.json'))
# populate(data)

data = JSON.load(open('https://raw.githubusercontent.com/el-cms/Open-trivia-database/master/en/todo/food_and_drink.json'))
populate(data)

data = JSON.load(open('https://raw.githubusercontent.com/el-cms/Open-trivia-database/master/en/todo/geography.json'))
populate(data)

data = JSON.load(open('https://raw.githubusercontent.com/el-cms/Open-trivia-database/master/en/todo/history.json'))
populate(data)

data = JSON.load(open('https://raw.githubusercontent.com/el-cms/Open-trivia-database/master/en/todo/language.json'))
populate(data)

data = JSON.load(open('https://raw.githubusercontent.com/el-cms/Open-trivia-database/master/en/todo/mathematics.json'))
populate(data)

data = JSON.load(open('https://raw.githubusercontent.com/el-cms/Open-trivia-database/master/en/todo/music.json'))
populate(data)

data = JSON.load(open('https://raw.githubusercontent.com/el-cms/Open-trivia-database/master/en/todo/people_and_places.json'))
populate(data)

data = JSON.load(open('https://raw.githubusercontent.com/el-cms/Open-trivia-database/master/en/todo/religion_and_mythology.json'))
populate(data)

data = JSON.load(open('https://raw.githubusercontent.com/el-cms/Open-trivia-database/master/en/todo/science_and_nature.json'))
populate(data)

data = JSON.load(open('https://raw.githubusercontent.com/el-cms/Open-trivia-database/master/en/todo/sport_and_leisure.json'))
populate(data)

data = JSON.load(open('https://raw.githubusercontent.com/el-cms/Open-trivia-database/master/en/todo/toys_and_games.json'))
populate(data)

data = JSON.load(open('https://raw.githubusercontent.com/el-cms/Open-trivia-database/master/en/todo/tech_an_video_games.json'))
populate(data)



# Questionnaire.delete_all
# Category.delete_all

# data = JSON.load(open('https://raw.githubusercontent.com/el-cms/Open-trivia-database/master/en/todo/food_and_drink.json'))
# populate(data)

# tiebreaker = Category.create(:title => 'Tiebreaker')
# space = Category.create(:title => 'Space')
# geo = Category.create(:title => 'Geography')
# history = Category.create(:title => 'History')
# sci = Category.create(:title => 'Science')
#
# Questionnaire.create(:title => "What is the name of the first planet in our solar system?", :answer => "Mercury", :category_id => space.id)
# Questionnaire.create(:title => "How many dwarf planets are recognized International Astronomical Union (IAU)", :answer => "5", :category_id => space.id)
# Questionnaire.create(:title => "Smallest and densest stars are called what? (not counting the hypothetical stars)", :answer => "Neutron Star", :category_id => space.id)
# Questionnaire.create(:title => "God particle is called what?", :answer => "Higg", :category_id => space.id)
# Questionnaire.create(:title => "What type of galaxy is the most common in the universe?", :answer => "Spiral Glaxy", :category_id => space.id)
# Questionnaire.create(:title => "What is the most common type of star found in the Milky Way?", :answer => "Red Dwarf Star", :category_id => space.id)
# Questionnaire.create(:title => "Which planet has the most voolcanoes", :answer => "Venus", :category_id => space.id)
# Questionnaire.create(:title => "First woman in space was from which country?", :answer => "Russia", :category_id => space.id)
# Questionnaire.create(:title => "Which planet is the hottest in our solar system?", :answer => "Venus", :category_id => space.id)
# Questionnaire.create(:title => "Which president established NASA?", :answer => "Dwight D. Eisenhower", :category_id => space.id)
# Questionnaire.create(:title => "Is it true that in space when two pieces of metal stoick together and they bond?", :answer => "yes", :category_id => space.id)
#
# Questionnaire.create(:title => "What's the smallest state in U.S.A", :answer => "Rhode Island", :category_id => geo.id)
# Questionnaire.create(:title => "How many states have a border with Mexico?", :answer => "4", :category_id => geo.id)
# Questionnaire.create(:title => "Which place has 43 buildings with their own zip code?", :answer => "NYC", :category_id => geo.id)
# Questionnaire.create(:title => "Which U.S state touches only one state?", :answer => "Maine", :category_id => geo.id)
# Questionnaire.create(:title => "Name the highest point in the country?", :answer => "Denali", :category_id => geo.id)
# Questionnaire.create(:title => "Which state has the longest coast line in the U.S?", :answer => "Alaska", :category_id => geo.id)
# Questionnaire.create(:title => "Sacramento is the capital of which state?", :answer => "California", :category_id => geo.id)
# Questionnaire.create(:title => "Name the lowest point of the country?", :answer => "Death Valley", :category_id => geo.id)
# Questionnaire.create(:title => "Name the tallest mountain in U.S?", :answer => "Mount McKinley", :category_id => geo.id)
# Questionnaire.create(:title => "Which U.S State has thehighest number of endangered species?", :answer => "Hawaii", :category_id => geo.id)
#
# Questionnaire.create(:title => "In which year did the Titanic sink?", :answer => "1912", :category_id => history.id)
# Questionnaire.create(:title => "In which year was Abraham Lincoln assassinated?", :answer => "1865", :category_id => history.id)
# Questionnaire.create(:title => "Name the second wife of Henry VIII?", :answer => "Anne Boleyn", :category_id => history.id)
# Questionnaire.create(:title => "Who invented the thermometer in 1593?", :answer => "Galileo", :category_id => history.id)
# Questionnaire.create(:title => "In which decade did compulsory driving testing begin?", :answer => "1930", :category_id => history.id)
# Questionnaire.create(:title => "What disease killed thousands of people in Glasgow in 1832?", :answer => "Cholera", :category_id => history.id)
# Questionnaire.create(:title => "Who was the only American to become vice president and president after resignations?", :answer => "Gerald Ford", :category_id => history.id)
# Questionnaire.create(:title => "What 19th-century president erroneously noted: “The ballot is stronger than the bullet”?", :answer => "Abraham Lincoln", :category_id => history.id)
# Questionnaire.create(:title => "Who was the only President to serve two non-consecutive terms", :answer => "Grover Cleveland", :category_id => history.id)
# Questionnaire.create(:title => "Which U.S. President signed the treaty to purchase Alaska from Russia?", :answer => "Andrew Johnson", :category_id => history.id)
#
# Questionnaire.create(:title => "If an object is in free fall, what is the only force that is acting upon that object?", :answer => "Gravity", :category_id => sci.id)
# Questionnaire.create(:title => "What is the name of the science of sound?", :answer => "Acoustics", :category_id => sci.id)
# Questionnaire.create(:title => "Where does sound travel faster; water or air?", :answer => "Water", :category_id => sci.id)
# Questionnaire.create(:title => "Can you lick your elbow?", :answer => "No", :category_id => sci.id)
# Questionnaire.create(:title => "What is the heaviest organ in the human body?", :answer => "Liver", :category_id => sci.id)
# Questionnaire.create(:title => "Who was the first woman to win a Nobel Prize (for Physics in 1903)", :answer => "Marie Curie", :category_id => sci.id)
# Questionnaire.create(:title => "Diamonds are mostly composed of which element?", :answer => "Carbon", :category_id => sci.id)
# Questionnaire.create(:title => "Which type of blood is rarest in humans?", :answer => "AB negative", :category_id => sci.id)
# Questionnaire.create(:title => "Which is the longest type of cell in a human body?", :answer => "The Neuron", :category_id => sci.id)
# Questionnaire.create(:title => "what does DC stand for?", :answer => "Direct Current", :category_id => sci.id)
#
# Questionnaire.create(:title => "Tiebreaker question 1", :answer => "Tiebreaker answer 1", :category_id => tiebreaker.id)
# Questionnaire.create(:title => "Tiebreaker question 2", :answer => "Tiebreaker answer 2", :category_id => tiebreaker.id)
# Questionnaire.create(:title => "Tiebreaker question 3", :answer => "Tiebreaker answer 3", :category_id => tiebreaker.id)
# Questionnaire.create(:title => "Tiebreaker question 4", :answer => "Tiebreaker answer 4", :category_id => tiebreaker.id)
# Questionnaire.create(:title => "Tiebreaker question 5", :answer => "Tiebreaker answer 5", :category_id => tiebreaker.id)
# Questionnaire.create(:title => "Tiebreaker question 6", :answer => "Tiebreaker answer 6", :category_id => tiebreaker.id)
# Questionnaire.create(:title => "Tiebreaker question 7", :answer => "Tiebreaker answer 7", :category_id => tiebreaker.id)
# Questionnaire.create(:title => "Tiebreaker question 8", :answer => "Tiebreaker answer 8", :category_id => tiebreaker.id)
# Questionnaire.create(:title => "Tiebreaker question 9", :answer => "Tiebreaker answer 9", :category_id => tiebreaker.id)
# Questionnaire.create(:title => "Tiebreaker question 10", :answer => "Tiebreaker answer 10", :category_id => tiebreaker.id)
