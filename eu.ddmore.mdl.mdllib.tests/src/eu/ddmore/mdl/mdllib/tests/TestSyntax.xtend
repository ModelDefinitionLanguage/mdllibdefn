package eu.ddmore.mdl.mdllib.tests

import com.google.inject.Inject
import eu.ddmore.mdl.mdllib.MdlLibInjectorProvider
import eu.ddmore.mdl.mdllib.mdllib.Library
import eu.ddmore.mdl.mdllib.scoping.MdlLibLib
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.util.ParseHelper
import org.eclipse.xtext.junit4.validation.ValidationTestHelper
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(XtextRunner)
@InjectWith(MdlLibInjectorProvider)
class TestSyntax {
	
	@Inject extension MdlLibLib
	
	@Inject extension ParseHelper<Library>
	@Inject	extension ValidationTestHelper

	@Test 
	def void testFunctionDeclnSyntax() {
		val result = '''
			func foo named (Arg1::Int, arg2::Int) 
				returns::Real;
			func bar "A basic function" (a1::Int "The argument 1", a2::Real "Arg 2")
				returns ::Real;
			func och "A test function" named (arg1::Int) returns::String;
			func aye named (arg1::Boolean) returns::Vector;
		'''.loadLibAndParse

		result.assertNoErrors
	}
	
	@Test 
	def void testNamedFunctionDeclnSyntax() {
		val result = '''
			func foo named (arg1::Int, arg2::Int , arg3::String)
					sig (arg1, arg2),
						(arg1, arg3?)
				returns::Real;
		'''.loadLibAndParse

		result.assertNoErrors
	}
	
	@Test 
	def void testUnnamedFunctionDeclnSyntax() {
		val result = '''
			func och "A test function" ( a1::Int ) returns::String;
		'''.loadLibAndParse

		result.assertNoErrors
	}
	
	@Test 
	def void testUnnamedFunctionNoDocsNoArgsDeclnSyntax() {
		val result = '''
			func och () returns::String;
		'''.loadLibAndParse

		result.assertNoErrors
	}
	
	@Test 
	def void testUnnamedFunctionNoDocsNoArgsNoReturnDeclnSyntax() {
		val result = '''
			func och () returns ::Real;
		'''.loadLibAndParse

		result.assertNoErrors
	}

	@Test 
	def void testMultiLineUnnamedFunctionsDeclnsSyntax() {
		val result = '''
			func och "A test function" ( a1::Int ) returns::String,
				aye "A test function" ( a1::Int ) returns::String;
		'''.loadLibAndParse

		result.assertNoErrors
	}
	
	@Test
	def void testUnnamedFuncLib(){
		val result = '''
			func log "Log of x to base y"
					(
						x::Real "the value",
						y::Real "the base"
					)
					returns ::Real,
				log2 
					(x::Real)
					returns ::Real,
				log10
					(x::Real)
					returns ::Real,
				ln(
					x::Real
					) returns ::Real
				;
		'''.loadLibAndParse
		result.assertNoErrors
	}

	@Test
	def void testNamedFuncLib(){
		val result = '''
		type TransType _enum (ln, logit, probit);
		type FixEffectSublist _sublist;
		
		func Normal named
						(mean::Real,
						sd::Real,
						var::Real
					)
					sig (mean, sd),
						(mean, var)
					returns ::Pdf,
			MultivariateNormal named
					(
						mean::Vector,
						cov::Matrix
					)
					returns ::Vector[::Pdf],
			matrix named
					(
						vector::Vector,
						ncol::Real,
						byRow::Boolean
					)
					returns ::Matrix,
			linear named
					( 
						trans::TransType,
						pop::Real,
						fixEff::Vector[::FixEffectSublist],
						ranEff::Vector
					)
					sig(trans?, pop, fixEff?, ranEff) 
					returns ::Real,
			combinedError1 named
					( 
						trans::TransType,
						additive::Real,
						proportional::Real,
						prediction::Real,
						eps::Real
					)
					sig(trans?, additive, proportional, prediction, eps)
					returns ::Real
			;
		'''.loadLibAndParse
		result.assertNoErrors
	}

	def private loadLibAndParse(CharSequence p) {
		p.parse(loadLibrary)
	}
	
	def private loadLibrary() {
		loadLib => [
			resources.forEach [
				contents.get(0).assertNoErrors
			]
		]
	}
}