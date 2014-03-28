Date.class_eval do
   def after?(time)
      self > time if time.is_a?(Date)
   end

   def before?(time)
      self < time if time.is_a?(Date)
   end
   
   def is_past?
      self < Date.today
   end
end
