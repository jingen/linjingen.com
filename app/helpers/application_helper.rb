module ApplicationHelper
  def stylesheet(*files)
    content_for(:mycss) { stylesheet_link_tag(*files) }
  end
  def javascript(*files)
    content_for(:myjs) { javascript_include_tag(*files) }
  end
end
