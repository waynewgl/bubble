#encoding: UTF-8

module CodeHelper

  @response = Hash.new

  def self.USER_DISTANCE

    return 300.0
  end

  def self.DISTANCE_METER_UPDATE

    return 10.0
  end


  def self.CODE_SUCCESS

    @response[:code] = "200"
    @response[:desc] = "操作成功"
    return @response
  end

  def self.CODE_FAIL

    @response[:code] = "222"
    @response[:desc] = "操作失败"
    return @response
  end

  def self.CODE_REFRESH

    @response[:code] = "255"
    @response[:desc] = "重新刷新"
    return @response
  end

  def self.CODE_EVENT_FAIL

    @response[:code] = "292"
    @response[:desc] = "无事件"
    return @response
  end

  def self.CODE_USER_LOGGED_IN

    @response[:code] = "299"
    @response[:desc] = "该用户已经登陆"
    return @response
  end

  def self.CODE_MISSING_PARAMS(arr_params)

    @response[:code] = "223"

    s = ""

    if !arr_params.nil?

      for para in  arr_params

        s << "#{para},"

      end

      @response[:desc] = "需要提供参数 " + s

    else
      @response[:desc] = "缺少必要参数"
    end


    return @response
  end

  def self.CODE_MISSING_PARAMS_POST_ID

    @response[:code] = "227"
    @response[:desc] = "缺少帖子id"
    return @response
  end

  def self.CODE_MISSING_PARAMS_USER_ID

    @response[:code] = "299"
    @response[:desc] = "缺少用户ID"
    return @response
  end

  def self.CODE_USER_NOT_EXIST

    @response[:code] = "225"
    @response[:desc] = "登陆失败，用户名或者密码错误"
    return @response
  end

  def self.CODE_TOKEN_NOT_EXIST

    @response[:code] = "228"
    @response[:desc] = "用户token不存在或者失效"
    return @response
  end

  def self.CODE_PASSPORT_TOKEN_NOT_EXIST

    @response[:code] = "228"
    @response[:desc] = "用户passport token不存在或者失效"
    return @response
  end

end
