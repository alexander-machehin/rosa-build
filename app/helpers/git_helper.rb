module GitHelper

  def render_path
    # TODO: Looks ugly, rewrite with clear mind.
    if @path.present?
      if @treeish == "master"
        res = "#{link_to @project.name, tree_path(@platform, @repository, @project)} / "
      else
        res = "#{link_to @project.name, tree_path(@platform, @repository, @project, @treeish)} / "
      end

      parts = @path.split("/")

      current_path = parts.first
      res += parts.length == 1 ? parts.first : link_to(parts.first, tree_path(@platform, @repository, @project, @treeish, current_path)) + " / "

      parts[1..-2].each do |part|
        current_path = File.join([current_path, part].compact)
        res += link_to(part, tree_path(@platform, @repository, @project, @treeish, current_path))
        res += " / "
      end

      res += parts.last if parts.length > 1
    else
      res = "#{link_to @project.name, tree_path(@platform, @repository, @project)} /"
    end

    res.html_safe
  end

  def render_line_numbers(n)
    res = ""
    1.upto(n) {|i| res += "<span>#{i}</span>\n" }

    res
  end

  def render_blob(blob)
    res = ""
    blob.data.split("\n").collect{|line| "<div>#{line.present? ? h(line) : "<br>"}</div>"}.join
  end

end