Ruby Calisthenics
=================

The goal of this multi-part assignment is to get you accustomed to basic
Ruby coding and introduce you to RSpec, the unit testing tool we will be
using heavily.

While we provide an explanation of how your code should work in this
handout, you should get accustomed to the idea that the true
specification is in the test files!

Therefore, we suggest you work on this assignment using `autotest`,
which automatically re-runs all the RSpec tests each time you make
changes to your code:

1. In a terminal window, change to the root directory of this homework
(the one containing subdirectories `lib/` and `spec/`) and run the
command `autotest`.  RSpec expects to find code files under `lib/` and
the corresponding spec files under `spec/`.

2. Initially, all tests are marked
"pending", as indicated by the argument `:pending => true` in each
`describe` block.  To start working on a question, remove this option:


e.g. in `fun_with_strings_spec.rb`, change:

    describe 'palindrome detection', :pending => true do

to

    describe 'palindrome detection' do

and save the spec file.  `autotest` will
detect the change and automatically re-run the tests in that group, which
will now fail (displayed in red) since you haven't written any code yet.

3. As you fill in code in the appropriate files under `lib/`, each time
you save changes to that file the tests will automatically be re-run.
When a test passes, it's displayed in green.  Your goal is to get all
tests for all parts to pass green.

(Note: when you submit your assignment, we may also run additional
test cases beyond the ones given here.)

# Fun With Words and Strings
--- fun_with_strings

Specs: `spec/fun_with_strings_spec.rb`

In this problem, you'll implement three functions that perform
basic string processing.  You can start from the template
`fun_with_strings.rb`.

## Part A: Palindromes

A palindrome is a word or phrase that reads the same forwards as
backwards, ignoring case, punctuation, and nonword characters.  (A
"nonword character" is defined for our purposes as "a character that
Ruby regular expressions would treat as a nonword character".) 

You will write a method `palindrome?` that returns true iff its
receiver is a palindrome.

As you can see in the template `fun_with_strings.rb`, we arrange to mix
your method into the `String` class so it can be called like this:

    "redivider".palindrome?    # => should return true
    "adam".palindrome?         # => should return false or nil

Your solution shouldn't use loops or iteration of any kind. Instead, you
will find regular-expression syntax very useful; it's reviewed briefly
in the book, and the [Rubular](http://www.rubular.com) website
lets you try out Ruby
regular expressions "live". Some methods that you might find useful
(which you'll have to look up in the [Ruby
documentation](http://ruby-doc.org)) include
`String#downcase`, `String#gsub`, and `String#reverse`.

The spec file contains a number of test cases.  At a minimum, all should
pass before you submit your code.  We may run additional cases as well.

## Part B:  Word Count

Define a function `count_words` that, given an input string, return a
hash whose keys are words in the string and whose values are the number
of times each word appears:

    "To be or not to be"  # => {"to"=>2, "be"=>2, "or"=>1, "not"=>1}

Your solution shouldn't use for-loops, but iterators like `each` are
permitted. As before, nonwords and case should be ignored. A word is
defined as a string of characters between word boundaries. 

## Part C:  Anagrams

An anagram group is a group of words such that any one can be converted
into any other just by rearranging the letters.  For example, "rats",
"tars" and "star" are an anagram group.

Given an array of strings, write a method that groups them into anagram
groups and returns the array of groups. Case doesn't matter in
classifying string as anagrams (but case should be preserved in the
output), and the order of the anagrams in the groups doesn't matter. 

# Part 2: Basic Object-Oriented Programming for Dessert

Specs: `spec/dessert_spec.rb`

1. Create a class Dessert with getters and setters for name and
calories.  The constructor should accept arguments for name and
calories.  

2. Define instance methods `healthy?`, which returns true iff a
dessert has less than 200 calories, and `delicious?`, which returns true
for all desserts. 

3. Create a class JellyBean that inherits from Dessert.  The constructor
should accept a single argument giving the jelly bean's flavor; a
newly-created jelly  bean should have 5 calories and its name should be
the flavor plus "jelly bean", for example, "strawberry jelly bean".

4. Add a getter and setter for the flavor. 

5. Modify `delicious?` to return false if the flavor is
`licorice`, but true for all other flavors.  The behavior of
`delicious?` for non-jelly-bean desserts should be unchanged.

# Part 3: Rock-Paper-Scissors

Specs: `spec/rock_paper_scissors_spec.rb`

In a game of rock-paper-scissors, each player chooses to play Rock (R),
Paper (P), or Scissors (S). The rules are: Rock breaks Scissors, Scissors
cuts Paper, but Paper covers Rock. 

In a round of rock-paper-scissors, each player's name and strategy is
encoded as an array of two elements

    [ "Armando", "P" ]  # => Armando plays Paper
    [ "Dave", "S" ]     # => Dave plays Scissors

(In this example, Dave would win because Scissors cuts Paper.)

## 1. Game Winner

Create a `RockPaperScissors` class with a *class* method `winner` that
takes two 2-element arrays like those above, and returns the one
representing the winner:

    RockPaperScissors.winner(['Armando','P'], ['Dave','S'])
       # => ['Dave','S']

If either player's strategy is something other than "R", "P" or "S"
(case-insensitive), the method should raise a
`RockPaperScissors::NoSuchStrategyError` exception.

If both players use the same strategy, the first player is the winner.

## 2. Tournament

A rock-paper-scissors tournament is encoded as an array of games -
that is, each element can be considered its own tournament.

    [
      [
        [ ["Armando", "P"], ["Dave", "S"] ],      
        [ ["Richard", "R"], ["Michael", "S"] ]
      ],
      [
        [ ["Allen", "S"], ["Omer", "P"] ],
        [ ["David E.", "R"], ["Richard X.", "P"] ]
      ]
    ]

Under this scenario, Dave would beat Armando (S>P) and Richard would
beat Michael (R>S), so Dave and Richard would play (Richard wins since
R>S); similarly, Allen would beat Omer, David E. would beat Richard X.,
and Allen and Richard X. would play (Allen wins since S>P); and finally
Richard would beat Allen since R>P.  That is, pairwise play continues
until there is only a single winner. 

Write a method `RockPaperScissors.tournament_winner'
that takes a tournament encoded as an 
array and returns the winner (for the above example, it should return
['Richard', 'R']). You can assume that the array is well formed (that
is, there are 2^n players, and each one participates in exactly one
match per round). 

HINT: Formulate the problem as a recursive one whose base case you
solved in part 1.

## 4. Ruby metaprogramming

Specs:  `spec/attr_accessor_with_history_spec.rb`

In lecture we saw how  `attr_accessor` uses metaprogramming to create
getters and setters for object attributes on the fly.

Define a method `attr_accessor_with_history` that provides the same
functionality as attr accessor but also tracks every value the attribute
has ever had: 

    class Foo 
      attr_accessor_with_history :bar
    end
    f = Foo.new        # => #<Foo:0x127e678>
    f.bar = 3          # => 3
    f.bar = :wowzo     # => :wowzo
    f.bar = 'boo!'     # => 'boo!'
    f.bar_history      # => [nil, 3, :wowzo]

(Calling `bar_history` before `bar`'s setter is ever called should
return `nil`.)

History of instance variables should be maintained separately for each
object instance. that is:

    f = Foo.new
    f.bar = 1 ; f.bar = 2
    g = Foo.new
    g.bar = 3 ; g.bar = 4
    g.bar_history

then the last line should just return `[nil,3]`, rather than
`[nil,1,2,3]`.

If you're interested in how the template works,
the first thing to notice is that if we define
`attr_accessor_with_history` in class `Class`, we can use it as in the
snippet 
above. This is because a Ruby class like `Foo` or `String` is actually just an
object of class `Class`. (If that makes your brain hurt, just don't worry
about it for now. It'll come.) 

The second thing to notice is that Ruby
provides a method `class_eval` that takes a string and evaluates it in the
context of the current class, that is, the class from which you're
calling `attr_accessor_with_history`. This string will need to contain a
method definition that implements a setter-with-history for the desired
attribute `attr_name`. 

HINTS:

* Don't forget that the very first time the attribute receives a value,
its history array will have to be initialized.  
* An
attribute's initial value is always `nil` by default, so if
`foo_history` is referenced before `foo` has ever been assigned, the
correct answer is `nil`, but after the first assignment to `foo`, the
correct value for `foo_history` would be `[nil]`.
* Don't forget that instance variables are referred to as `@bar` within getters and setters, as Section 3.4 of ELLS explains.
* Although the existing `attr_accessor` can handle multiple arguments (e.g. `attr_accessor :foo, :bar`), your version just needs to handle a single argument.
* Your implementation should be genreal enough to work in the context of any class and for attributes of any (legal) variable name

