module CardsHelper
  def init_project_task
    @project.tasks.collect{|u| [u.name, u.id]}
      .insert(0, t("card.select_task"))
  end
end
