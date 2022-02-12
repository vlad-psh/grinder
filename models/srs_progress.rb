class SrsProgress < ActiveRecord::Base
  belongs_to :user
  belongs_to :progress

  scope :expired, -> {where(SrsProgress.arel_table[:scheduled].lteq(Date.today))}

  enum learning_type: {reading: 0, writing: 1, listening: 2}

  def answer!(a, drill = nil)
    # answer should be 'yes', 'no' or 'soso'
    a = a.to_sym

    if a == :correct
      self.attributes = attributes_of_correct_answer
    elsif a == :incorrect
      self.attributes = attributes_of_incorrect_answer
      self.fail_count += 1
    elsif a == :soso
      self.attributes = attributes_of_soso_answer
    end

    self.attributes = drill_attributes_for_answer(a, drill) if drill.present?

    self.reviewed_at = DateTime.now
    self.save
  end

  def drill_attributes_for_answer(answer, drill)
    if answer == :correct
      box = leitner_box == nil ? drill.leitner_session : leitner_box
      combo = leitner_combo + 1
    elsif answer == :incorrect
      box = nil
      combo = 0
    elsif answer == :soso
      box = leitner_box == nil ? drill.leitner_session : leitner_box
      combo = leitner_combo # no change
    end

    return {
      leitner_box: box,
      leitner_combo: combo,
      leitner_last_reviewed_at_session: drill.leitner_session,
    }
  end

  def attributes_of_correct_answer
    _deck = self.deck
    _transition = self.transition

    if Date.today <= self.transition && self.last_answer != 'correct'
      if self.last_answer == 'soso'
        return {scheduled: Date.today + SRS_RANGES[self.deck]}
      elsif self.last_answer == 'incorrect'
        return {scheduled: Date.today < self.scheduled ? Date.today + 3 : self.transition}
      end
    end

    if Date.today >= self.transition
      _deck += 1 if _deck < 7 # 7th is the highest deck
      _transition += SRS_RANGES[_deck]
      # Move transition date forward by (deck_range/2) if it still less than today
      _transition = Date.today + SRS_RANGES[_deck] / 2 if _transition < Date.today
    end
    _percent = (Date.today - _transition + SRS_RANGES[_deck]) / SRS_RANGES[_deck].to_f
    # percent should not be > 1.0 because of previous condition (with dates)

# TODO: ADD VARIATION TO SCHEDULE DATE (+/- 20% ?)
# UPD: Maybe no need to (because we now doesn't gave Statistic.schedule and graph of upcoming elements counts)
    add_to_scheduled = SRS_RANGES[_deck] * (1 + _percent) # add full next interval + fraction of it
    add_to_scheduled = SRS_RANGES.last if add_to_scheduled > SRS_RANGES.last # should not be > 240 (or...? maybe allow?)
    return {
      deck: _deck,
      transition: _transition,
      scheduled: Date.today + add_to_scheduled,
      last_answer: :correct
    }
  end

  def attributes_of_soso_answer
    if Date.today <= self.transition && self.last_answer == 'incorrect'
      return {scheduled: Date.today < self.scheduled ? Date.today + 3 : self.transition}
    end

    # Leave in the same deck; move transition date forward
    _transition = Date.today + SRS_RANGES[self.deck]
    return {
      deck: self.deck,
      transition: _transition,
      scheduled: _transition,
      last_answer: :soso
    }
  end

  def attributes_of_incorrect_answer
    _deck = self.deck > 1 && self.last_answer != 'incorrect' ? self.deck - 1 : self.deck
    return {
      deck: _deck,
      transition: Date.today + SRS_RANGES[_deck],
      scheduled: _deck > 0 ? Date.today + 3 : Date.today,
      last_answer: :incorrect
    }
  end

  def html_class_leitner
    if leitner_last_reviewed_at_session == nil
      :pristine
    elsif leitner_box == nil || leitner_combo <= 1
      :apprentice
    elsif leitner_combo >= 4
      :master
    else
      :guru
    end
  end

end
