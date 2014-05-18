class Dessert

  attr_accessor :name, :calories

  def initialize(name, calories)
    # your code here
    @name = name
    @calories = calories
  end
  def healthy?
    # your code here
    calories < 200
  end
  def delicious?
    # your code here
    true
  end
end

# class JellyBean inherited from Dessert class
class JellyBean < Dessert
  def initialize(flavor)
    # your code here
    @flavor = flavor
    @name = flavor + " jelly bean"
    @calories = 5
  end

  def delicious?
    @flavor != "licorice"
  end

end
