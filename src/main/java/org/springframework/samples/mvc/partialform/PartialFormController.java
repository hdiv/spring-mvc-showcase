package org.springframework.samples.mvc.partialform;

import java.util.ArrayList;
import java.util.List;

import javax.validation.Valid;

import org.hdiv.dataComposer.IDataComposer;
import org.hdiv.util.HDIVUtil;
import org.springframework.mvc.extensions.ajax.AjaxUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.context.request.WebRequest;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/partialform")
@SessionAttributes("formBean")
public class PartialFormController {

	private List<String> suggestTypes = new ArrayList<String>();

	public PartialFormController() {
		this.suggestTypes.add("Improvement");
		this.suggestTypes.add("Bugfix");
		this.suggestTypes.add("New feature");
	}

	// Invoked on every request

	@ModelAttribute
	public void ajaxAttribute(WebRequest request, Model model) {
		model.addAttribute("ajaxRequest", AjaxUtils.isAjaxRequest(request));
	}

	// Invoked initially to create the "form" attribute
	// Once created the "form" attribute comes from the HTTP session (see @SessionAttributes)

	@ModelAttribute("partialFormBean")
	public PartialFormBean createFormBean() {
		return new PartialFormBean();
	}

	@RequestMapping(method = RequestMethod.GET)
	public void form() {
	}

	@RequestMapping(method = RequestMethod.POST)
	public String processSubmit(@Valid PartialFormBean formBean, BindingResult result,
			@ModelAttribute("ajaxRequest") boolean ajaxRequest, Model model, RedirectAttributes redirectAttrs) {
		if (result.hasErrors()) {
			return null;
		}
		// Typically you would save to a db and clear the "form" attribute from the session 
		// via SessionStatus.setCompleted(). For the demo we leave it in the session.
		String message = "Form submitted successfully.  Bound " + formBean;
		// Success response handling
		if (ajaxRequest) {
			// prepare model for rendering success message in this request
			model.addAttribute("message", message);
			return null;
		} else {
			// store a success message for rendering on the next request after redirect
			// redirect back to the form to render the success message along with newly bound values
			redirectAttrs.addFlashAttribute("message", message);
			return "redirect:/partialform";
		}
	}

	@RequestMapping(value = "/suggestTypes", method = RequestMethod.GET, produces = "application/json")
	public @ResponseBody
	List<String> getSuggestTypes() {

		//Call to Hdiv to add the new parameter value to the state
		IDataComposer dataComposer = HDIVUtil.getDataComposer();
		for (String val : suggestTypes) {
			dataComposer.compose("suggestType", val, true);
		}

		return this.suggestTypes;
	}

}
