# encoding: utf-8
module ApplicationHelper
  def markdown(text)
    options = {:hard_wrap => true, :filter_html => true, :autolink => true,
               :no_intraemphasis => true, :fenced_code => true, :gh_blockcode => true}
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, options)
    markdown.render(text).html_safe
  end

  def menu_link_to(*args, &block)
    link_path = args[1].match(/(\/{1}\w*)\/?/)[1]
    path = request.path.match(/(\/{1}\w*)\/?/)[1] # extract the father controller

    class_property = "active" if path == link_path
    content_tag :li, :class => class_property do
      link_to *args, &block
    end
  end

  def twitterized_type(type)
    case type
    when :alert
      "alert"
    when :error
      "alert-error"
    when :notice
      "alert-info"
    when :success
      "alert-success"
    else
      type.to_s
    end
  end

  def javascript(*args)
    content_for(:head) { javascript_include_tag(*args) }
  end

  def controller_namespace
    rs = controller.class.name.split("::")
    rs.size > 1 ? rs.first.downcase : ""
  end


  def show_link(object, content = "Show")
    link_to(content, object) if can?(:read, object)
  end

  def edit_link(object, content = "Edit", kclass = "" )
    link_to(content, [:edit, object], class: kclass) if can?(:update, object)
  end

  def destroy_link(object, content = "Destroy")
    link_to(content, object, :method => :delete, :confirm => "Tem certeza?") if can?(:destroy, object)
  end

  def create_link(object, content = "New")
    if can?(:create, object)
      object_class = (object.kind_of?(Class) ? object : object.class)
      link_to(content, [:new, object_class.name.underscore.to_sym])
    end
  end

  def creator(user)
    if user && user.has_name?
        user.name
    else
      user.email
    end
  end

  def name_or_email(user)
    creator(user)
  end

   def nested_comments(comments, model)
    comments.map do |comment|
      render(comment, model: model) +
         content_tag(:div, nested_comments(comment.child_comments, model), :class => "nested_comments")
    end.join.html_safe
  end
end
