{
	programs.git = {
		enable = true;
		settings = {
			user = {
				name = "Chrisser1";
				email = "chrisgthomsen0310@gmail.com";
			};

			url."git@github.com:" = {
				insteadOf = "https://github.com/";
			};
		};
	};
}
