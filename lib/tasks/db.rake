#encoding: utf-8
namespace :db do

  desc "This populate database"
  task :populate => :environment do
    require 'faker'

    [LearningObject, Fractal, Exercise].each(&:destroy_all)

    User.delete_all
    User.create(email: 'carrie.ufpr@gmail.com', password: 'carrie123', type: 'admin',
                password_confirmation: 'carrie')
    professor = User.create(email: 'professor@gmail.com', password: 'professor', type: 'professor',
                password_confirmation: 'professor')
    student = User.create(email: 'student@gmail.com', password: 'student', type: 'student',
                password_confirmation: 'student')

    oas = 10.times.map do
      oa = LearningObject.create(
        :name => Faker::Name.name,
        :description => Faker::Lorem.paragraphs(2).join
      )
      3.times {oa.introductions.create( title: Faker::Name.title , content: Faker::Lorem.paragraphs(3).join) }
      oa
    end

    fractals = []
    fractals << student.fractals.create({:name => "HeighWay Dragon", :angle => 90, :axiom => "FX",
                                :rules => ['X=X+YF+', 'Y=-FX-Y']})
    fractals << student.fractals.create({:name => "Kevs Tree", :angle => 22, :axiom => "F",
                                :rules => ['F=C0FF-[C1-F+F+F]+[C2+F-F-F]']})
    fractals << professor.fractals.create({:name => "Sierpinsk Triangle", :angle => 120, :axiom => "F-G-G",
                                :rules => ['F=F-G+F+G-F', 'G=GG']})
    fractals << professor.fractals.create({:name => "Knoch Snowflake", :angle => 60, :axiom => "F++F++F",
                                :rules => ['F=F-F++F-F', 'X=FF']})
    fractals << student.fractals.create({:name => "Knoch Curve", :angle => 90, :axiom => "-F",
                                :rules => ['F=F+F-F-F+F']})

    10.times.each do |i|
      frac = fractals.sample
      Fractal.create({:name => " #{frac.name} #{i}", :angle => frac.angle,
                      :axiom => frac.axiom, :rules => frac.rules, :user_id => frac.user_id })
    end

    fractals_exerc = []

    fractals.each do |frac|
      fractals_exerc << FractalExercise.new({:name => frac.name ,:iterations => (3..5).to_a.sample,
                                             :angle => frac.angle,
                                             :axiom => frac.axiom, :rules => frac.rules, :slug => frac.slug})

    end

    oas.each do |oa|
      3.times do
        exe = oa.exercises.create!(:title => Faker::Name.title, :enunciation => Faker::Lorem.paragraphs(3).join,
                            :fractal_exercise => fractals_exerc.sample)
        3.times do |i|
          exe.questions.create!( title: "Lado Maior #{i}", enunciation: "Enunciado #{i}")
        end

      end
    end

  end
end
