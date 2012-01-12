#encoding: utf-8
namespace :db do

  desc "This populate database"
  task :populate => :environment do
    require 'faker'

    [LearningObject, Fractal, Exercise].each(&:destroy_all)

    oas = 10.times.map do
      LearningObject.create(
        :name => Faker::Name.name,
        :description => Faker::Lorem.paragraphs(2).join
      )
    end

    fractals = []
    fractals << Fractal.create({:name => "HeighWay Dragon", :angle => 90, :axiom => "FX",
                                :rules => ['X=X+YF+', 'Y=-FX-Y']})
    fractals << Fractal.create({:name => "Kevs Tree", :angle => 22, :axiom => "F",
                                :rules => ['F=C0FF-[C1-F+F+F]+[C2+F-F-F]']})
    fractals << Fractal.create({:name => "Sierpinsk Triangle", :angle => 120, :axiom => "F-G-G",
                                :rules => ['F=F-G+F+G-F', 'G=GG']})
    fractals << Fractal.create({:name => "Knoch Snowflake", :angle => 60, :axiom => "F++F++F",
                                :rules => ['F=F-F++F-F', 'X=FF']})
    fractals << Fractal.create({:name => "Knoch Curve", :angle => 90, :axiom => "-F",
                                :rules => ['F=F+F-F-F+F']})

    10.times.each do |i|
      frac = fractals.sample
      Fractal.create({:name => " #{frac.name} #{i}", :angle => frac.angle, :axiom => frac.axiom,
                                :rules => frac.rules})
    end

    fractals_exerc = []

    fractals.each do |frac|
      fractals_exerc << FractalExercise.new({:name => frac.name ,:iterations => (1..10).to_a.sample,
                                             :angle => frac.angle,
                                             :axiom => frac.axiom, :rules => frac.rules, :slug => frac.slug})

    end

    oas.each do |oa|
      3.times do
        exe = oa.exercises.create!(:title => Faker::Name.title, :enunciation => Faker::Lorem.paragraphs(3).join,
                            :fractal_exercise => fractals_exerc.sample)
        3.times { |i| exe.questions.create!( title: "Lado Maior #{i}", enunciation: "Enunciado #{i}") }
      end
    end

  end
end
