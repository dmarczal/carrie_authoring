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


    fractals_exerc = []
    fractals_exerc << FractalExercise.new({:name => "HeighWay Dragon" ,:iterations => 12, :angle => 90,
                                           :axiom => "FX", :rules => ['X=X+YF+', 'Y=-FX-Y']})
    fractals_exerc << FractalExercise.new({:name => "Kevs Tree", :iterations => 5, :angle => 22,
                                           :axiom => "F", :rules => ['F=C0FF-[C1-F+F+F]+[C2+F-F-F]']})
    fractals_exerc << FractalExercise.new({:name => "Sierpinsk Triangle", :iterations => 6, :angle => 120,
                                           :axiom => "F-G-G", :rules => ['F=F-G+F+G-F', 'G=GG']})
    fractals_exerc << FractalExercise.new({:name => "Knoch Snowflake", :iterations => 4, :angle => 60,
                                           :axiom => "F++F++F", :rules => ['F=F-F++F-F', 'X=FF']})
    fractals_exerc << FractalExercise.new({:name => "Knoch Curve", :iterations => 4, :angle => 90,
                                           :axiom => "-F", :rules => ['F=F+F-F-F+F']})

    oas.each do |oa|
      3.times do
        oa.exercises.create!(:title => Faker::Name.title, :enunciation => Faker::Lorem.paragraphs(3).join,
                            :fractal_exercise => fractals_exerc.sample)
      end
    end

  end
end
