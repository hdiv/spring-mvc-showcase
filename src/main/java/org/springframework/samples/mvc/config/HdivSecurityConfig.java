package org.springframework.samples.mvc.config;

import org.hdiv.config.annotation.EnableHdivWebSecurity;
import org.hdiv.config.annotation.ExclusionRegistry;
import org.hdiv.config.annotation.RuleRegistry;
import org.hdiv.config.annotation.ValidationConfigurer;
import org.hdiv.config.annotation.builders.SecurityConfigBuilder;
import org.hdiv.config.annotation.configuration.HdivWebSecurityConfigurerAdapter;
import org.springframework.context.annotation.Configuration;

@Configuration
@EnableHdivWebSecurity
public class HdivSecurityConfig extends HdivWebSecurityConfigurerAdapter {

	@Override
	public void configure(final SecurityConfigBuilder builder) {

		builder.sessionExpired().homePage("/").loginPage("/login.html").and()//
				.maxPagesPerSession(10)//
				.reuseExistingPageInAjaxRequest(true);
	}

	@Override
	public void addExclusions(final ExclusionRegistry registry) {

		registry.addUrlExclusions("/").method("GET");

		registry.addUrlExclusions(".*.js");
		registry.addUrlExclusions(".*.css");
		registry.addUrlExclusions(".*.png");

		registry.addParamExclusions("_csrf");
		registry.addParamExclusions("fruit,foo").forUrls("/messageconverters/form");
		registry.addParamExclusions("ajaxUpload").forUrls("/fileupload");
	}

	@Override
	public void addRules(final RuleRegistry registry) {

		registry.addRule("safeText").acceptedPattern("^[a-zA-Z0-9@.\\-_]*$");
	}

	@Override
	public void configureEditableValidation(final ValidationConfigurer validationConfigurer) {

		validationConfigurer.addValidation(".*").rules("safeText");
	}
}
