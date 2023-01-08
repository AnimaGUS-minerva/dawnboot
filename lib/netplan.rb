
class Netplan

  def parse_file(file)
    file = File.open(file)
    parse_yaml(file.read)
  end

  def parse_yaml(yaml)
    YAML::load(yaml)
  end

end
