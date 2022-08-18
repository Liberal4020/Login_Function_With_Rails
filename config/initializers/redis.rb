# redisクライアントのインスタンスを生成してRedis.currentでアクセスできるようにする
Redis.current = Redis.new(
  host: ENV["REDIS_HOST"],
  port: ENV["REDIS_PORT"],
  db: ENV["REDIS_DB"]
)