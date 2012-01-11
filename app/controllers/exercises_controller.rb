#encoding: utf-8
class ExercisesController < ApplicationController

  before_filter :authenticate_user!
  before_filter :find_learning_object, :only => [:create, :new, :show, :update]

  def create
    frac = create_fractal(params[:exercise][:fractal_exercise])
    params[:exercise][:fractal_exercise] = nil
    @exercise = @learning_object.exercises.new
    @exercise.title= params[:exercise][:title]
    @exercise.enunciation= params[:exercise][:enunciation]
    @exercise.fractal_exercise = frac

    if @exercise.save
      redirect_to @learning_object, :notice => "Exercício criado com sucesso, defina agora as questões"
    else
      render :new
    end
  end

  def new
    @exercise = @learning_object.exercises.new
    add_breadcrumb "Novo Exercício #{@exercise.title}", :new_learning_object_exercise_path
  end


  def update
      @exercise = @learning_object.exercises.find_by_slug(params[:id])
      @exercise.update_attributes(params[:exercise])

      if params[:exercise][:fractal]
        frac = create_fractal(params[:exercise][:fractal])
        @exercise.fractal_exercise= frac
      end

      respond_to do |format|
        if @exercise.save
          format.html { redirect_to(@exercise,
                        notice: "As informações do Exercício #{@exercise.title} foram atualizadas.") }
          format.json { respond_with_bip(@exercise) }
        else
          format.html { render :edit }
          format.json { respond_with_bip(@exercise) }
        end
      end
  end

  def show
    @exercise = @learning_object.exercises.find_by_slug(params[:id])
    @fractal  = @exercise.fractal
    @fractals = Fractal.all.map{|fractal| [fractal.id, fractal.name]}

    add_breadcrumb "Exercício: #{@exercise.title}", :learning_object_exercise_path
  end

  def update_fractal_size
    oa = LearningObject.find_by_slug(params[:oa_id])
    exerc = oa.exercises.find_by_slug(params[:id])
    frac = exerc.fractal
    frac.width= params[:width].to_f
    frac.height= params[:height].to_f
    exerc.save!
    render nothing: true;
  end


private
  def find_learning_object
    @learning_object = LearningObject.find_by_slug(params[:learning_object_id])

    add_breadcrumb "Objetos de Aprendizagem", learning_objects_path
    add_breadcrumb "OA: #{@learning_object.name}", learning_object_path(@learning_object)
  end

  def create_fractal(id)
    fractal = Fractal.find(id)
    if fractal
      frac_exer = FractalExercise.new(name: fractal.name, angle: fractal.angle,
                                      axiom: fractal.axiom, constant: fractal.constant,
                                      rules: fractal.rules)

      return frac_exer
    end
  end
end
