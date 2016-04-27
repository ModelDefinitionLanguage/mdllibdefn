/*******************************************************************************
 * Copyright (c) 2016 Pfizer Ltd.
 *
 * This file is part of the MDL Library.
 *
 * The MDL Library is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * The MDL Library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with The MDL Library.  If not, see <http://www.gnu.org/licenses/>.
 *******************************************************************************/
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
			_func foo _named (Arg1::Int, arg2::Int) _sig(Arg1), (arg2)
				_returns::Real;
			_func bar "A basic function" (a1::Int "The argument 1", a2::Real "Arg 2")
				_returns ::Real;
			_func och "A test function" _named (arg1::Int) _sig(arg1) _returns::String;
			_func aye _named (arg1::Boolean)_sig(arg1)  _returns::Vector;
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
			_func och "A test function" ( a1::Int ) _returns::String;
			_func aye "A test function" ( a1::Int ) _returns::String;
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
					_returns ::Real;
			_func log2 
					(x::Real)
					_returns ::Real;
			_func	log10
					(x::Real)
					_returns ::Real;
			_func	ln(
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
		_sublist FixEffectSublist _atts cov::Reference[::Real]
					_sig (cov);
							
		_func Normal _named
						(mean::Real,
						sd::Real,
						var::Real
					)
					_sig (mean, sd),
						(mean, var)
					_returns ::Pdf;
		_func MultivariateNormal _named
					(
						mean::Vector,
						cov::Matrix
					)
					_sig(mean, cov)
					_returns ::Vector[::Pdf];
		_func	matrix _named
					(
						vector::Vector,
						ncol::Real,
						byRow::Boolean
					)
					_sig(vector, ncol, byRow)
					_returns ::Matrix;
		_func	linear _named
					( 
						trans::TransType,
						pop::Real,
						fixEff::Vector[::FixEffectSublist],
						ranEff::Vector
					)
					_sig(trans?, pop, fixEff?, ranEff) 
					_returns ::Real;
		_func	combinedError1 _named
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