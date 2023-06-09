class ConversationsController < ApplicationController
    # GET /conversations
    def index
        authorizer = AuthorizeApiRequest.new(request.headers)
        res = authorizer.call
        user = res[:user]
        @convo = Conversation.where(user1_id: user.id).or(Conversation.where(user2_id: user.id))
        @res = []
        for i in @convo do
            convo_id = i.id
            convo_partner = User.find_by(id: i.user2.id)
            msg = Message.where(conversation_id: convo_id).last
            with_user = { 
                'id' => convo_partner.id,
                'name' => convo_partner.name,
                'photo_url' => convo_partner.photo_url
            }
            last_message = {
                'id' => msg.id,
                'sender' => {
                    'id' => msg.sender.id,
                    'name' => msg.sender.name
                },
                'sent_at' => msg.created_at
            } 
            unread_count = i.user1_unread_count
            ret_data = {
                "id" => i.id,
                "with_user" => with_user,
                "last_message" => last_message,
                "unread_count" => unread_count,
            }
            @res.push(ret_data)
        end
        json_response(@res)
    end

    # GET /conversations/:id
    def show
        authorizer = AuthorizeApiRequest.new(request.headers)
        res = authorizer.call
        user_logon = res[:user]
        convo = Conversation.find_by(id: params[:id])
        if convo == nil
            return head :not_found
        end
        if user_logon.id != params[:id]
            return head :forbidden
        end
        if user_logon.id == convo.user1_id
            convo_partner = User.find_by(id: convo.user2.id)
        else
            convo_partner = User.find_by(id: convo.user1.id)
        end
        @res = {
            "id" => convo.id,
            "with_user" => {
                "id" => convo_partner.id,
                "name" => convo_partner.name,
                "photo_url" => convo_partner.photo_url
            }
        }
        json_response(@res)
    end
end
