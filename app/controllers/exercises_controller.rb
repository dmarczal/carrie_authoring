#encoding: utf-8
class ExercisesController < ApplicationController

  before_filter :authenticate_user!
  before_filter :find_learning_object, :except => [:update_fractal_size]
  load_and_authorize_resource :find_by => :slug

  def create
    @exercise = @learning_object.exercises.new
    create_fractal([:exercise][:fractal])
    params[:exercise][:fractal_exercise] = nil
    @exercise.title= params[:exercise][:title]
    @exercise.enunciation= params[:exercise][:enunciation]


    if @exercise.save
      redirect_to @learning_object, :notice => "Exercício criado com sucesso, defina agora as questões"
    else
      render :new
    end
  end

  def new
    @exercise = @learning_object.exercises.new
    @exercise.fractal_exercise = FractalExercise.new
    add_breadcrumb "Novo Exercício #{@exercise.title}", :new_learning_object_exercise_path
  end

  def edit
    @exercise = @learning_object.exercises.find_by_slug(params[:id])
    @fractal  = @exercise.fractal
  end

  def update
      @exercise = @learning_object.exercises.find_by_slug(params[:id])
      @exercise.title= params[:exercise][:title]
      @exercise.enunciation= params[:exercise][:enunciation]


      if params[:exercise][:fractal]
          create_fractal(params[:exercise][:fractal])
      end
      @exercise.fractal.name = params[:exercise][:fractal_exercise][:name]
      @exercise.fractal.infinite = params[:exercise][:fractal_exercise][:infinite]
      @exercise.fractal.angle = params[:exercise][:fractal_exercise][:angle]
      @exercise.fractal.constant = params[:exercise][:fractal_exercise][:constant]
      @exercise.fractal.axiom= params[:exercise][:fractal_exercise][:axiom]
      @exercise.fractal.iterations = params[:exercise][:fractal_exercise][:iterations]
      @exercise.fractal.width = params[:exercise][:fractal_exercise][:width]
      @exercise.fractal.height = params[:exercise][:fractal_exercise][:height]

      respond_to do |format|
        if @exercise.save
          format.html { redirect_to(@learning_object,
                        notice: "As informações do Exercício #{@exercise.title} foram atualizadas.") }
        else
          format.html { render :edit }
        end
      end
  end

  def show
    @exercise = @learning_object.exercises.find_by_slug(params[:id])
    @fractal  = @exercise.fractal
    @fractals = Fractal.all.map{|fractal| [fractal.id, fractal.name]}
    @questions = @exercise.questions.order_by([[ :position, :asc ]])

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

  def destroy
    @exercise = @learning_object.exercises.find_by_slug(params[:id]);
    @exercise.destroy

    redirect_to @learning_object, notice: "OA deletado com sucesso"
  end

  def show_questions
    @learning_object = LearningObject.find_by_slug(params[:learning_object_id])
    @exercise = @learning_object.exercises.find_by_slug(params[:exercise_id])
    @questions = @exercise.questions.order_by([[ :position, :asc ]])

    add_breadcrumb "Exercício: #{@exercise.title}", learning_object_exercise_path(@learning_object, @exercise)
    add_breadcrumb "Ordenação de Questões", :learning_object_exercise_show_questions_path

    render :show_questions
  end

  def sort_questions
    @exercise = @learning_object.exercises.find_by_slug(params[:id])
    params[:question].each_with_index do |id, index|
      id = id.gsub('question_', '')
      @exercise.questions.find(id).update_attribute(:position, index+1)
    end
    render nothing: true
  end

  def show_help_question
    render :help
  end

private
  def find_learning_object
    @learning_object = LearningObject.find_by_slug(params[:learning_object_id])

    add_breadcrumb "Objetos de Aprendizagem", learning_objects_path
    add_breadcrumb "OA: #{@learning_object.name}", learning_object_path(@learning_object)
  end

  def create_fractal(id)
    fractal = Fractal.find_by_slug(id)
    if fractal
      frac_exer = @exercise.build_fractal_exercise(name: fractal.name, angle: fractal.angle,
                                      axiom: fractal.axiom, constant: fractal.constant,
                                      rules: fractal.rules, slug: fractal.slug )

      #return frac_exer
    end
  end
end
