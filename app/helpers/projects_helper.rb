module ProjectsHelper
  def manager_hightlight member
    return "btn-primary" if is_manager? member
    "btn-success"
  end

  def is_manager? member
    Relationship.find_by(user_id: member.id, project_id: @project.id)
      .is_manager?
  end

  def is_project_manager?
    @is_manager ||= current_user.is_project_manager? @project
  end
end
