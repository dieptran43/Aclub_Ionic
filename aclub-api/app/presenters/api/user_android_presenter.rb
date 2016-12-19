module Api  
  
  class UserAndroidPresenter < Presenter
    def as_json(*)
      {
        id: object.id,
        name: object.name,
        email: object.email,
        phone: object.phone,
        avatar: object.avatar1,
        email_verification_token: object.email_verification_token,
        facebook_image_url: object.facebook_image_url,
        facebook_token: object.facebook_token,
        created_at: object.created_at,
        facebook_token_expiration: object.facebook_token_expiration,
        location: object.location,
        unverified_email: object.unverified_email,
        updated_at: object.updated_at,
        verification_token: object.verification_token,
      }
    end
  end
end
