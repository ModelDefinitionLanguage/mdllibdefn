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
import eu.ddmore.mdllib.mdllib.Library
import eu.ddmore.mdllib.scoping.MdlLibLib
import org.eclipse.xtext.testing.XtextRunner
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.util.ParseHelper
import org.eclipse.xtext.testing.validation.ValidationTestHelper
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
			_func foo _named (Arg1::int, arg2::int) _sig(Arg1), (arg2)
				_returns::real;
			_func bar "A basic function" (a1::int "The argument 1", a2::real "Arg 2")
				_returns ::real;
			_func och "A test function" _named (arg1::int) _sig(arg1) _returns::string;
			_func aye _named (arg1::boolean)_sig(arg1)  _returns::vector;
		'''.loadLibAndParse

		result.assertNoErrors
	}
	
	@Test 
	def void testNamedFunctionDeclnSyntax() {
		val result = '''
			_func foo _named (arg1::int, arg2::int , arg3::string)
					_sig (arg1, arg2),
						(arg1, arg3?)
				_returns::real;
		'''.loadLibAndParse

		result.assertNoErrors
	}
	
	@Test 
	def void testUnnamedFunctionDeclnSyntax() {
		val result = '''
			_func och "A test function" ( a1::int ) _returns::string;
		'''.loadLibAndParse

		result.assertNoErrors
	}
	
	@Test 
	def void testUnnamedFunctionNoDocsNoArgsDeclnSyntax() {
		val result = '''
			_func och () _returns::string;
		'''.loadLibAndParse

		result.assertNoErrors
	}
	
	@Test 
	def void testUnnamedFunctionNoDocsNoArgsNoReturnDeclnSyntax() {
		val result = '''
			_func och () _returns ::real;
		'''.loadLibAndParse

		result.assertNoErrors
	}

	@Test 
	def void testMultiLineUnnamedFunctionsDeclnsSyntax() {
		val result = '''
			_func och "A test function" ( a1::int ) _returns::string;
			_func aye "A test function" ( a1::int ) _returns::string;
		'''.loadLibAndParse

		result.assertNoErrors
	}
	
	@Test 
	def void testVectorOfVectorArgumentSyntax() {
		val result = '''
			_func och "A test function" ( a1::vector[::vector[::real]]) _returns::string;
		'''.loadLibAndParse

		result.assertNoErrors
	}
	
	@Test 
	def void testVectorOfVectorArgumentSpacedSyntax() {
		val result = '''
			_func och "A test function" ( a1::vector[::vector[::real] ]) _returns::string;
		'''.loadLibAndParse

		result.assertNoErrors
	}
	
	@Test 
	def void testVectorOfVectorReturnSyntax() {
		val result = '''
			_func och "A test function" ( a1::real) _returns::vector[::vector[::real]];
		'''.loadLibAndParse

		result.assertNoErrors
	}
	
	@Test 
	def void testVectorOfVectorReturnSpacedSyntax() {
		val result = '''
			_func och "A test function" ( a1::real) _returns::vector[::vector[::real] ];
		'''.loadLibAndParse

		result.assertNoErrors
	}
	
	@Test
	def void testUnnamedFuncLib(){
		val result = '''
			_func log "Log of x to base y"
					(
						x::real "the value",
						y::real "the base"
					)
					_returns ::real;
			_func log2 
					(x::real)
					_returns ::real;
			_func	log10
					(x::real)
					_returns ::real;
			_func	ln(
					x::real
					) _returns ::real
				;
		'''.loadLibAndParse
		result.assertNoErrors
	}

	@Test
	def void testNamedFuncLib(){
		val result = '''
		_type TransType _enum (ln, logit, probit);
		_sublist FixEffectSublist _atts cov::reference[::real]
					_sig (cov);
							
		_func Normal _named
						(mean::real,
						sd::real,
						var::real
					)
					_sig (mean, sd),
						(mean, var)
					_returns ::pdf;
		_func MultivariateNormal _named
					(
						mean::vector,
						cov::matrix
					)
					_sig(mean, cov)
					_returns ::vector[::pdf];
		_func	matrix _named
					(
						vector::vector,
						ncol::real,
						byRow::boolean
					)
					_sig(vector, ncol, byRow)
					_returns ::matrix;
		_func	linear _named
					( 
						trans::TransType,
						pop::real,
						fixEff::vector[::FixEffectSublist],
						ranEff::vector
					)
					_sig(trans?, pop, fixEff?, ranEff) 
					_returns ::real;
		_func	combinedError1 _named
					( 
						trans::TransType,
						additive::real,
						proportional::real,
						prediction::real,
						eps::real
					)
					_sig(trans?, additive, proportional, prediction, eps)
					_returns ::real
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