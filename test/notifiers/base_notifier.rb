class BaseNotifier < Fourseam::Base
  def welcome(hash = {})
    push apn: 'device-token', fcm: true
  end

  def missing_apn_template
    push apn: 'device-token'
  end

  def missing_fcm_template
    push fcm: true
  end

  def with_apn_template
    push apn: 'device-token'
  end

  def with_fcm_template
    push fcm: true
  end
end
