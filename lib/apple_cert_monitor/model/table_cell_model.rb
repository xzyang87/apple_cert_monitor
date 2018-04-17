class TableCellModel

  MODEL_TYPES = {
      is_certificate: 1, # 证书
      is_provisioning_profile: 2, # 描述文件
  }

  attr_accessor :name
  attr_accessor :days_to_now
end