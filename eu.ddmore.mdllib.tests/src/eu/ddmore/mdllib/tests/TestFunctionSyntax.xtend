package eu.ddmore.mdllib.tests

import com.google.inject.Inject
import eu.ddmore.mdllib.MdlLibInjectorProvider
import eu.ddmore.mdllib.mdllib.Library
import eu.ddmore.mdllib.scoping.MdlLibLib
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.util.ParseHelper
import org.eclipse.xtext.junit4.validation.ValidationTestHelper
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(XtextRunner)
@InjectWith(MdlLibInjectorProvider)
class TestFunctionSyntax {
	
	@Inject extension MdlLibLib
	
	@Inject extension ParseHelper<Library>
	@Inject	extension ValidationTestHelper

	@Test 
	def void testFunctionDeclnSyntax() {
		val result = '''
			_func foo _named (Arg1::Int, arg2::Int) 
				_returns::Real;
			_func bar "A basic function" (a1::Int "The argument 1", a2::Real "Arg 2")
				_returns ::Real;
			_func och "A test function" _named (arg1::Int) _returns::String;
			_func aye _named (arg1::Boolean) _returns::Vector;
		'''.loadLibAndParse

		result.assertNoErrors
	}
	
	@Test 
	def void testNamedFunctionDeclnSyntax() {
		val result = '''
			_func foo _named (arg1::Int, arg2::Int , arg3::String)
					_sig (arg1, arg2),
						(arg1, arg3?)
				_returns::Real;
		'''.loadLibAndParse

		result.assertNoErrors
	}
	
	@Test 
	def void testUnnamedFunctionDeclnSyntax() {
		val result = '''
			_func och "A test function" ( a1::Int ) _returns::String;
		'''.loadLibAndParse

		result.assertNoErrors
	}
	
	@Test 
	def void testUnnamedFunctionNoDocsNoArgsDeclnSyntax() {
		val result = '''
			_func och () _returns::String;
		'''.loadLibAndParse

		result.assertNoErrors
	}
	
	@Test 
	def void testUnnamedFunctionNoDocsNoArgsNoReturnDeclnSyntax() {
		val result = '''
			_func och () _returns ::Real;
		'''.loadLibAndParse

		result.assertNoErrors
	}

	@Test 
	def void testMultiLineUnnamedFunctionsDeclnsSyntax() {
		val result = '''
			_func och "A test function" ( a1::Int ) _returns::String,
				aye "A test function" ( a1::Int ) _returns::String;
		'''.loadLibAndParse

		result.assertNoErrors
	}
	
	@Test 
	def void testVectorOfVectorArgumentSyntax() {
		val result = '''
			_func och "A test function" ( a1::Vector[::Vector[::Real]]) _returns::String;
		'''.loadLibAndParse

		result.assertNoErrors
	}
	
	@Test 
	def void testVectorOfVectorArgumentSpacedSyntax() {
		val result = '''
			_func och "A test function" ( a1::Vector[::Vector[::Real] ]) _returns::String;
		'''.loadLibAndParse

		result.assertNoErrors
	}
	
	@Test 
	def void testVectorOfVectorReturnSyntax() {
		val result = '''
			_func och "A test function" ( a1::Real) _returns::Vector[::Vector[::Real]];
		'''.loadLibAndParse

		result.assertNoErrors
	}
	
	@Test 
	def void testVectorOfVectorReturnSpacedSyntax() {
		val result = '''
			_func och "A test function" ( a1::Real) _returns::Vector[::Vector[::Real] ];
		'''.loadLibAndParse

		result.assertNoErrors
	}
	
	@Test
	def void testUnnamedFuncLib(){
		val result = '''
			_func log "Log of x to base y"
					(
						x::Real "the value",
						y::Real "the base"
					)
					_returns ::Real,
				log2 
					(x::Real)
					_returns ::Real,
				log10
					(x::Real)
					_returns ::Real,
				ln(
					x::Real
					) _returns ::Real
				;
		'''.loadLibAndParse
		result.assertNoErrors
	}

	@Test
	def void testNamedFuncLib(){
		val result = '''
		_type TransType _enum (ln, logit, probit);
		_type FixEffectSublist _sublist;
		
		_func Normal _named
						(mean::Real,
						sd::Real,
						var::Real
					)
					_sig (mean, sd),
						(mean, var)
					_returns ::Pdf,
			MultivariateNormal _named
					(
						mean::Vector,
						cov::Matrix
					)
					_returns ::Vector[::Pdf],
			matrix _named
					(
						vector::Vector,
						ncol::Real,
						byRow::Boolean
					)
					_returns ::Matrix,
			linear _named
					( 
						trans::TransType,
						pop::Real,
						fixEff::Vector[::FixEffectSublist],
						ranEff::Vector
					)
					_sig(trans?, pop, fixEff?, ranEff) 
					_returns ::Real,
			combinedError1 _named
					( 
						trans::TransType,
						additive::Real,
						proportional::Real,
						prediction::Real,
						eps::Real
					)
					_sig(trans?, additive, proportional, prediction, eps)
					_returns ::Real
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