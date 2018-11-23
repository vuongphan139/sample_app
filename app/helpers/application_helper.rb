module ApplicationHelper
  def full_title page_title = ""
    base_title = t :ror_tut_sample_app
    page_title.empty? ? base_title : page_title + " | " + base_title
  end
end
