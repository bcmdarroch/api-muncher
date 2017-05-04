require 'httparty'

class EdamamApiWrapper
  BASE_URL = "https://api.edamam.com/"
  APP_ID = ENV["APP_ID"]
  APP_KEY = ENV["APP_KEY"]

  def self.listRecipes(search_term, app_id = nil, app_key = nil)
    app_id ||= APP_ID
    app_key ||= APP_KEY

    search_term = search_term.gsub(/\s/, '+')

    url = BASE_URL + "search?q=#{ search_term }&" + "app_id=#{ app_id }&" + "app_key=#{ app_key }"

    response = HTTParty.get(url).parsed_response["hits"]

    recipes = []
    if response
      response.each_with_index do |recipe, i|
        recipe_hash = {
          "id" => response[i]["recipe"]["uri"].gsub('#', '%23'),
          "label" => response[i]["recipe"]["label"],
          "image" => response[i]["recipe"]["image"]
        }
        recipes << Recipe.new(recipe_hash)
      end
    end

    return recipes
  end

  def self.getRecipe(id, app_id = nil, app_key = nil)
    app_id ||= APP_ID
    app_key ||= APP_KEY

    url = BASE_URL + "search?r=#{ id }&" + "app_id=#{ app_id }&" + "app_key=#{ app_key }"

    response = HTTParty.get(url).parsed_response[0]

    if response
      recipe_hash = {
        "id" => response["uri"].gsub('#', '%23'),
        "label" => response["label"],
        "image" => response["image"],
        "url" => response["url"],
        "ingredientLines" => response["ingredientLines"],
        "dietLabels" => response["dietLabels"],
        "healthLabels" => response["healthLabels"]
      }

      return Recipe.new(recipe_hash)
    else
      return false
    end
  end
end
