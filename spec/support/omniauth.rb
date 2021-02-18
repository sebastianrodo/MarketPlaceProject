def stub_env_for_omniauth_facebook
  request.env["devise.mapping"] = Devise.mappings[:user]

  request.env["omniauth.auth"] = OmniAuth::AuthHash.new({
    "provider" => "facebook",
    "uid" => "1234",
    "info"=> {
                "name"=>"SEBASTIAN ANDRES RODRIGUEZ DOMINGUEZ",
                "email"=>"sarodriguez5244@misena.edu.co",
                "first_name"=>"SEBASTIAN ANDRES",
                "last_name"=>"RODRIGUEZ DOMINGUEZ"
            }
  })
end

def stub_env_for_omniauth_google
  request.env["devise.mapping"] = Devise.mappings[:user]

  request.env["omniauth.auth"] = OmniAuth::AuthHash.new({
    "provider" => "google",
    "uid" => "1234",
    "info"=> {
                "name"=>"SEBASTIAN ANDRES RODRIGUEZ DOMINGUEZ",
                "email"=>"sarodriguez5244@misena.edu.co",
                "first_name"=>"SEBASTIAN ANDRES",
                "last_name"=>"RODRIGUEZ DOMINGUEZ"
            }
  })
end
