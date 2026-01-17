class Admin::LetterTemplatesController < Admin::BaseController
    before_action :set_letter_template, only: [:show, :edit, :update, :destroy, :set_default]

    def index
      @letter_templates = policy_scope(LetterTemplate).includes(:event).order(created_at: :desc)
    end

    def show
      authorize @letter_template
    end

    def new
      @letter_template = LetterTemplate.new
      @letter_template.event_id = params[:event_id] if params[:event_id].present?
      authorize @letter_template
    end

    def create
      @letter_template = LetterTemplate.new(letter_template_params)
      authorize @letter_template

      if @letter_template.save
        ActivityLog.log!(
          trackable: @letter_template,
          action: "template_created",
          admin: current_admin,
          request: request
        )
        redirect_to admin_letter_template_path(@letter_template), notice: "Letter template was successfully created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      authorize @letter_template
    end

    def update
      authorize @letter_template

      if @letter_template.update(letter_template_params)
        ActivityLog.log!(
          trackable: @letter_template,
          action: "template_updated",
          admin: current_admin,
          metadata: { changes: @letter_template.previous_changes },
          request: request
        )
        redirect_to admin_letter_template_path(@letter_template), notice: "Letter template was successfully updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      authorize @letter_template

      @letter_template.destroy
      ActivityLog.log!(
        trackable: @letter_template,
        action: "template_deleted",
        admin: current_admin,
        request: request
      )
      redirect_to admin_letter_templates_path, notice: "Letter template was successfully deleted."
    end

    def set_default
      authorize @letter_template

      LetterTemplate.where(is_default: true, event_id: nil).update_all(is_default: false)
      @letter_template.update!(is_default: true)

      ActivityLog.log!(
        trackable: @letter_template,
        action: "template_set_as_default",
        admin: current_admin,
        request: request
      )

      redirect_to admin_letter_templates_path, notice: "Template set as default."
    end

    private

    def set_letter_template
      @letter_template = LetterTemplate.find(params[:id])
    end

    def letter_template_params
      params.require(:letter_template).permit(
        :name, :body, :signatory_name, :signatory_title,
        :event_id, :is_default, :active,
        :signature_image, :letterhead_image
      )
    end
end
