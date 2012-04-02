Fabricator(:user) do
  name { sequence(:name) { |i| " carrieuser#{i}" } }
  email { |user| "#{user.name.parameterize}@gmail.com" }
  password '1234567'
  password_confirmation '1234567'
  type :professor
end

Fabricator(:fractal) do
  name {  sequence(:name) { |i| "HeighWay Dragon #{i}" } }
  iterations 5
  angle 90
  axiom "FX"
  rules ['X=X+YF+', 'Y=-FX-Y']
  user
end

Fabricator(:fractal_exercise) do
  name {  sequence(:name) { |i| "Fractal #{i}" } }
  iterations 5
  angle 90
  axiom "FX"
  rules ['X=X+YF+', 'Y=-FX-Y']
end

Fabricator(:exercise) do
  title { sequence(:title)  { |i| "Title #{i}" } }
  enunciation "Enunciation is about"
  learning_object
  fractal_exercise
end

Fabricator(:learning_object) do
  name { sequence(:name) { |i| "Objeto de Aprendizagem #{i}" } }
  description "Descriptions"
end

Fabricator(:learning_group) do
  name { sequence(:name) { |i| "Turma #{i}" } }
  code 1234
end
