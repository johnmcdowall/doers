# DOERS numeric [Field] STI class
class Field::Numerics < Field
  # Store accessors definition
  store_accessor :data, :title, :minimum, :maximum, :selected

  # Validations
  validates_presence_of :title, :minimum, :maximum, :selected
  validates_numericality_of :minimum, :less_than => :maximum
  validates_numericality_of :maximum, :greater_than => :minimum
  validates_numericality_of :selected, :greater_than_or_equal_to => :minimum
  validates_numericality_of :selected, :less_than_or_equal_to => :maximum

  # Callbacks
  # Sanitize user input
  before_validation do
    self.title = Sanitize.clean(self.title)
  end
end
