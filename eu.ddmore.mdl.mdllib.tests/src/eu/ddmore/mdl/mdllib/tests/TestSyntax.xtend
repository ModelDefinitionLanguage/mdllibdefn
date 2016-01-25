package eu.ddmore.mdl.mdllib.tests

import org.junit.runner.RunWith
import org.eclipse.xtext.junit4.XtextRunner
import eu.ddmore.mdl.mdllib.MdlLibInjectorProvider
import org.eclipse.xtext.junit4.InjectWith
import com.google.inject.Inject
import org.eclipse.xtext.junit4.util.ParseHelper
import org.eclipse.xtext.junit4.validation.ValidationTestHelper
import eu.ddmore.mdl.mdllib.mdlLib.Library
import org.junit.Test
import static org.junit.Assert.*

@RunWith(XtextRunner)
@InjectWith(MdlLibInjectorProvider)
class TestSyntax {
	
	@Inject extension ParseHelper<Library>
	@Inject	extension ValidationTestHelper

	@Test 
	def void loadModel() {
		val result = '''
			foo::Function() returns::Real;
			bar::Function();
			och::Function(arg1::Int) returns::String;
			aye::Function(arg1::Boolean) returns::Array;
		'''.parse

		result.assertNoErrors
	}

	@Test 
	def void parseFunctionWithArrayReturnType() {
		val result = '''
			the::Function(arg1::Int) returns::Array[::Int];
		'''.parse

		result.assertNoErrors
	}

	@Test 
	def void parseFunctionWithArrayArgType() {
		val result = '''
			the::Function(arg1::Array[::Int]);
		'''.parse

		result.assertNoErrors
	}


}