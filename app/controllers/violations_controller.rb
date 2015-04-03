class ViolationsController < ApplicationController

	def index
		@violations = Violation.all
		# format.html { render :application }
	end

end
