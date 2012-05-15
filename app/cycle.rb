class Cycle
  INFINITY = 1.0/0

  attr_reader :id
  attr_reader :max
  attr_reader :redis_key

  def initialize(id, options = {})
    @id = id
    @max = options[:max] || INFINITY
    @redis_key = "Cycle/#{id}"
  end

  def current
    if $redis.exists redis_key
      memo = $redis.incr redis_key
      if memo > max
        memo = 0
        $redis.set redis_key, 0
      end
    else
      memo = 0
      $redis.set redis_key, 0
    end
    memo
  end
  lock_method :current, :spin => true

  def as_lock
    id
  end
end
