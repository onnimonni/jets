describe Jets::Resource::Iam::ClassRole do
  let(:role) do
    Jets::Resource::Iam::ClassRole.new(PostsController)
  end

  context "iam policy" do
    it "inherits from the application wide iam policy" do
      # pp role.policy_document # uncomment to debug
      expect(role.policy_document).to eq(
        {"Version"=>"2012-10-17",
         "Statement"=>
          [{"Action"=>["lambda:*"], "Effect"=>"Allow", "Resource"=>"*"},
           {"Action"=>["logs:*"], "Effect"=>"Allow", "Resource"=>"*"},
           {"Action"=>["logs:*"],
            "Effect"=>"Allow",
            "Resource"=>
             "arn:aws:logs:us-east-1:123456789:log-group:/aws/lambda/demo-test-*"},
           {"Action"=>["cloudformation:DescribeStacks"],
            "Effect"=>"Allow",
            "Resource"=>
             "arn:aws:cloudformation:us-east-1:123456789:stack/demo-test*"}]}
      )
    end
  end
end