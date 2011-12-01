Fabricator(:fractal) do
  name {  sequence(:name) { |i| "HeighWay Dragon #{i}" } }
  iterations 5
  angle 90
  axiom "FX"
  rules ['X=X+YF+', 'Y=-FX-Y']
end

Fabricator(:exercise) do
  title { sequence(:title)  { |i| "Title #{i}" } }
  enunciation "Enunciation is about"
  learning_object
  fractal
end

Fabricator(:learning_object) do
  name { sequence(:name) { |i| "Objeto de Aprendizagem #{i}" } }
  description "Descriptions"
end
