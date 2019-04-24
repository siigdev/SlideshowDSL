package org.xtext.example.mydsl.generator

import org.eclipse.xtext.generator.IGeneratorContext
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.emf.ecore.resource.Resource
import org.xtext.example.mydsl.anislide.Template
import org.xtext.example.mydsl.generator.AnislideGenerator;
import org.xtext.example.mydsl.anislide.Global
import org.xtext.example.mydsl.anislide.Slide
import org.xtext.example.mydsl.anislide.Title
import org.xtext.example.mydsl.anislide.Tmplt
import org.xtext.example.mydsl.anislide.ProgressAnimation
import org.xtext.example.mydsl.anislide.Textcolor
import org.xtext.example.mydsl.anislide.BackgroundColor

class LatexGenerator extends AnislideGenerator  {
	new(Resource resource, IFileSystemAccess2 fsa, IGeneratorContext context) {
		initialise(resource, fsa, context);
		fsa.generateFile(title + ".tex", generateDocument());

	}
	def generateDocument() {
		'''
		% #########################
		% # GENERATED BY AniSlide #
		% #########################
		
		\documentclass{beamer}
		\usepackage{xcolor}
		«FOR global : model.global»
		«global.generateGlobal»
		«ENDFOR»
		
		«FOR progressani : model.progressanimations»
		«progressani.generateProgress»
		«ENDFOR»
		
		«FOR template : model.templates»
		«template.generateTemplate»
		«ENDFOR»
		\begin{document}
		«FOR slide : model.slides»
		«slide.generateSlide»
		«ENDFOR»
		
		\end{document}
		'''
	}
	
	def generateProgress(ProgressAnimation progressani) {
		'''
		% progressani
		'''
	}
	def generateGlobal(Global global) {
		'''
		% #########################
		% #  GLOBAL STYLE         #
		% #########################
		«FOR style : global.globalbody.styles»
				«style.generateGlobalEntity»
		«ENDFOR»
		
		\BeforeBeginEnvironment{frame}{%
	    	«FOR style : global.globalbody.styles»
  				«style.generateGlobalStyle»
      		«ENDFOR»
		}
		% #########################
		
		'''
	}
	def generateTemplate(Template template) {
		'''
		% #########################
		% #  TEMPLATE «template.name.toUpperCase» #
		% #########################
		«FOR style : template.templatebody.styles»
				«style.generateTemplateEntity»
		«ENDFOR»
		
		    \makeatletter
		    \define@key{beamerframe}{«template.name»}[true]{%
	    	«FOR style : template.templatebody.styles»
  				«style.generateTemplateStyle»
      		«ENDFOR»
		}
		% #########################
		'''
	}
	def generateSlide(Slide slide) {		
		'''
		{
		«FOR style : slide.slidebody.styles»
				«style.generate»
		«ENDFOR»
		\begin{frame}«FOR entity : slide.slidebody.slideentities»«IF entity.key == "template:"»«entity.generate»«ENDIF»«ENDFOR»
		«FOR entity : slide.slidebody.slideentities»
			«IF entity.key != "template:"»
				«entity.generate»
			«ENDIF»
		«ENDFOR»
		Write your text hereeee :)
		\end{frame}
		}
		'''
	}
	def dispatch generate(Title entity) {
		''' 
		\frametitle{«entity.value»}
		'''
	}
	def dispatch generate(Tmplt entity) {
		'''[«entity.value.name»]'''
	}
	def dispatch generate(Textcolor entity) {
		''' 
		\definecolor{TempText}{RGB}{«entity.value»}
		\setbeamercolor{normal text}{fg=TempText}
		'''
	}
	def dispatch generate(BackgroundColor entity) {
		''' 
		\definecolor{TempBG}{«entity.value»}
		\setbeamercolor{background canvas}{bg=TempBG}
		''' 
	}
	def dispatch generateGlobalEntity(BackgroundColor entity) {
		''' 
		\defbeamertemplate*{background canvas}{global}
		    {%		    
		      \definecolor{bgcolor}{rgb}{«entity.value»}\color{bgcolor}\vrule width\paperwidth height\paperheight
		}
		''' 
	}
	def dispatch generateGlobalEntity(Textcolor entity) {
		'''
		\definecolor{textcolor}{rgb}{«entity.value»}
		'''
	}
	def dispatch generateTemplateEntity(BackgroundColor entity) {
		'''
		\defbeamertemplate*{background canvas}{bg}
		    {%		    
		      \definecolor{bgcolor}{rgb}{«entity.value»}\color{bgcolor}\vrule width\paperwidth height\paperheight
		}      
		'''
	}
	def dispatch generateTemplateEntity(Textcolor entity) {
		'''
		\definecolor{textcolor}{rgb}{«entity.value»}
		'''
	}
	def dispatch generateGlobalStyle(BackgroundColor entity) {
		'''
		\setbeamertemplate{background canvas}[global]
		'''
	}
	def dispatch generateGlobalStyle(Textcolor entity) {
		'''
		\color{textcolor}
		'''	
	}
	def dispatch generateTemplateStyle(BackgroundColor entity) {
		'''
		\setbeamertemplate{background canvas}[bg]
		'''
	}
	def dispatch generateTemplateStyle(Textcolor entity) {
		'''
		\color{textcolor}
		'''	
	}
	def generateTemplateName(Tmplt templatename) {
		'''	[test] '''
	}
}