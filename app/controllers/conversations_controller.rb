class ConversationsController < ApplicationController
    # GET /conversations
    def index
        authorizer = AuthorizeApiRequest.new(request.headers)
        res = authorizer.call
        user = res[:user]
        puts(user.id)
        @conversations = Conversation.where(user1_id: user.id).or(Conversation.where(user2_id: user.id))
        # TODO : query message terakhir pakai id convo diatas
        # TODO : Unread count explore tambah field unread count user1 & user2 di convo model, bikin post route message, set integer message convo
        
        # @conversations = Conversation.where(user1_id: user.id)
        json_response(@conversations)
    end

    # GET /conversations/:id
    def show
        json_response(@todo)
    end
end
