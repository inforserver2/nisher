#encoding: UTF-8
class ContactsController < ApplicationController


  # GET /contacts/new
  # GET /contacts/new.json
  def new
    @contact = Contact.new
  end


  # POST /contacts
  # POST /contacts.json
  def create
    @contact = Contact.new(params[:contact], :as=>:guest)
    @contact.sponsor_id=@sponsor.id

    respond_to do |format|
      if @contact.valid?
        obj=@contact.to_json
        ContactMailer.delay.contact obj

        format.html { redirect_to :new_contact, notice: 'Dados enviados, responderemos tão breve possível.' }
      else
        format.html { render action: "new" }
      end
    end
  end

end
