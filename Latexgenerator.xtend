package org.xtext.example.mydsl.generator

import org.eclipse.xtext.generator.IGeneratorContext
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.emf.ecore.resource.Resource
import org.xtext.example.mydsl.anislide.Template
import org.xtext.example.mydsl.generator.AnislideGenerator;

class Latexgenerator extends AnislideGenerator  {
	new(Resource resource, IFileSystemAccess2 fsa, IGeneratorContext context) {
		initialise(resource, fsa, context);
		fsa.generateFile("title" + ".tex", generateDocument());

	}
	def generateDocument() {
		println("AHAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA")
		println(model.template)
		'''
		\documentclass{beamer}
				«FOR template : model.template»
					«template.generate»
				«ENDFOR»
		\end{document}
		'''
	}
	def generateTemplate() {
		'''
		
		'''
	}
	def dispatch generate(Template template) {
		return template.name
	}
}