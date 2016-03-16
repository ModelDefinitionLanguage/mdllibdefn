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
class TestListSyntax {
	
	@Inject extension MdlLibLib
	
	@Inject extension ParseHelper<Library>
	@Inject	extension ValidationTestHelper

	@Test 
	def void testListDeclnWithKeyValSyntax() {
		val result = '''
			_type divUse _enum (covariate, amt, dv, dvid, cmt, mdv, idv, id, rate, ignore, varLevel, catCov, ss, ii, addl);
			_list covList _alt Real _atts use::divUse
				_sig (use);
			_list catCovList _atts use::divUse
				_cat use::Int
			 	_sig (use);
			
			_block DATA_INPUT_VARIABLES (0,) _statements (1,) _listDefn
				_list _key=use divUse.covariate->covList, divUse.catCov->catCovList;
		'''.loadLibAndParse

		result.assertNoErrors
	}

	@Test 
	def void testListDecln2SigsSyntax() {
		val result = '''
			_list VarLevel 
				_atts use::Int , foo::Real, anot::String
				_sig (use, foo?), (anot, foo?);
			_block DATA_INPUT_VARIABLES (0, 1) _statements (0, 2) _eqnDefn, _eqnDefn+, _enumDefn, _rvDefn
				_list _key=use VarLevel;
		'''.loadLibAndParse

		result.assertNoErrors
	}

	@Test 
	def void testListDecln2SigsWithKeyValSyntax() {
		val result = '''
			_list VarLevel
				_atts use::Int , foo::Real, anot::String
				_sig (use, foo?), (anot, foo?);
			_block DATA_INPUT_VARIABLES (0, 1) _statements (0, 2) _eqnDefn, _eqnDefn+, _enumDefn, _rvDefn
				_list  _key=use VarLevel;
		'''.loadLibAndParse

		result.assertNoErrors
	}

	@Test 
	def void testListDeclnWithBlockOwners() {
		val result = '''
			_list VarLevel
				_atts type::Int , foo::Real, anot::String
				_sig (type, foo?), (anot, foo?);
			_block DATA_INPUT_VARIABLES (0, 1) _statements (0, 2) _eqnDefn, _eqnDefn+, _enumDefn, _rvDefn
				_list _key=type VarLevel;
		'''.loadLibAndParse

		result.assertNoErrors
	}

	@Test 
	def void testListDeclnWithSuperList() {
		val result = '''
			_list DerivSuper _super;
			_list myList _alt Deriv _extends DerivSuper
				_atts deriv::Real, foo::Reference[::Real], anot::String
				_sig (deriv, foo?), (anot, foo?)
				;
			_block DATA_INPUT_VARIABLES (0, 1) _statements (0, 2) _eqnDefn, _eqnDefn+, _enumDefn, _rvDefn
				_list _key=deriv myList;
		'''.loadLibAndParse

		result.assertNoErrors
	}

	@Test 
	def void testListDeclnWithCatMappings() {
		val result = '''
			_type divUse _enum (covariate, amt, dv, dvid, cmt, mdv, idv, id, rate, ignore, varLevel, catCov, ss, ii, addl);
			_list DerivSuper _super;
			_list VarLevel _alt Real _extends DerivSuper
				_atts use::divUse , foo::Real, anot::String
				_cat use::Int
				_sig (use, foo?), (anot, foo?)
				;
			_block DATA_INPUT_VARIABLES (0, 1) _statements (0, 2) _eqnDefn, _eqnDefn+, _enumDefn, _rvDefn
				_list _key=use divUse.covariate->VarLevel;
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