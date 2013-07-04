Fabricator(:board) do
  author(:fabricator => :user)
  title { Faker::Lorem.sentence }
end

Fabricator(:branched_board, :class_name => Board) do
  user
  project
  parent_board(:fabricator => :board)
  title { Faker::Lorem.sentence }
end

Fabricator(:persona_board, :class_name => Board) do
  title { sequence(:persona_title){|t| 'Persona board #%d' % t} }
  author(:fabricator => :user)
end

Fabricator(:problem_board, :class_name => Board) do
  title { sequence(:problem_title){|t| 'Problem board #%d' % t} }
  author(:fabricator => :user)
end

Fabricator(:solution_board, :class_name => Board) do
  title { sequence(:solution_title){|t| 'Solution board #%d' % t} }
  author(:fabricator => :user)
end
