# Monkey patch ActiveRecord logging to skip most updates to the delayed_jobs table
# See: https://blog.simplificator.com/2015/02/02/filter-rails-sql-log-in-production/
module ActiveRecord
  class LogSubscriber
    alias :old_sql :sql
 
    def sql(event)
      if event.payload[:sql].include? 'UPDATE `delayed_jobs` SET `delayed_jobs`.`locked_at`'
        t = Time.now
        # First five seconds of the hour
        if (t.min == 0) && (t.sec < 5)
          Rails.logger.
            debug('Delayed job filtered to be hourly (see filter_delayed_log_sql.rb)')
          old_sql(event)
        end
      else
        old_sql(event)
      end
    end
  end
end
